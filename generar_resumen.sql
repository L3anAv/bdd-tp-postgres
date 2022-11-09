CREATE OR REPLACE FUNCTION generar_resumen (nro_cliente cliente.nrocliente%TYPE, aux_año INT, aux_mes INT) RETURNS void AS $$

        DECLARE

	    
	    aux_nrolinea INT := 1;
	    aux_cliente RECORD;
	    aux_compra RECORD;
	    aux_tarjeta RECORD;
	    aux_cierre RECORD;
	    aux_comercio RECORD;
            aux_nroresumen cabecera.nroresumen%type;
            aux_total cabecera.total%type;

        BEGIN

                --guardo cliente pasado por parametro en aux_cliente
                SELECT * INTO aux_cliente FROM cliente WHERE nrocliente = nro_cliente;
	                IF NOT FOUND THEN --compruebo que nro_cliente pasado por parametro sea valido
	      		        RAISE 'El número de cliente % no existe.', nro_cliente;
  		        END IF;

                --recorro la o las tarjetas del cliente
                FOR aux_tarjeta IN SELECT * FROM tarjeta WHERE nrocliente = aux_cliente.nrocliente LOOP
        
		        aux_total := 0; --reinicio total a pagar

                        --guardo cierre de la tarjeta en aux_cierre, uso substring para saber su numero de terminacion y lo paso a int
		        SELECT * INTO aux_cierre FROM cierre WHERE año = aux_año AND mes = aux_mes
                                AND terminacion = substring(aux_tarjeta.nrotarjeta, 16, 1)::INT;

                        --creo cabecera sin nroresumen ya que es serial y se crea automaticamente
                        --total = 0
                        INSERT INTO cabecera (nombre, apellido, domicilio, nrotarjeta, desde, hasta, vence, total)
                                VALUES (aux_cliente.nombre, aux_cliente.apellido, aux_cliente.domicilio, aux_tarjeta.nrotarjeta, aux_cierre.fechainicio, aux_cierre.fechacierre, aux_cierre.fechavto, aux_total);

                        --guardo nroresumen autogenerado en aux_nroresumen para usarlo en detalle
                        INSERT INTO cabecera(nroresumen) SELECT nroresumen FROM cabecera WHERE nrotarjeta = aux_tarjeta.nrotarjeta
                                AND desde = aux_cierre.fechainicio AND hasta = aux_cierre.fechacierre;

                        --recorro compras
                        FOR aux_compra IN SELECT * FROM compra WHERE nrotarjeta = aux_tarjeta.nrotarjeta AND fecha >= aux_cierre.fechainicio AND fecha <= aux_cierre.fechacierre AND pagado = false LOOP

                                --guardo comercio en aux_comercio
                                SELECT * INTO aux_comercio FROM comercio WHERE nrocomercio = aux_compra.nrocomercio;

                                --creo detalle
                                INSERT INTO detalle (nroresumen, nrolinea, fecha, nombrecomercio, monto)
                                        VALUES (aux_nroresumen, aux_nrolinea, aux_compra.fecha, aux_comercio.nombre, aux_compra.monto);
			        aux_nrolinea := aux_nrolinea + 1; --incremento aux_nrolinea
                                aux_total := aux_total + aux_compra.monto; --incremento total
                                UPDATE compra SET pagado = true WHERE nrooperacion = aux_compra.nrooperacion; --actualizo bool pagado
                        END LOOP;

                        UPDATE cabecera SET total = aux_total WHERE nrotarjeta = aux_tarjeta.nrotarjeta --actualizo total en cabecera
                                AND desde = aux_cierre.fechainicio AND hasta = aux_cierre.fechacierre;
                        
                END LOOP;
        END;
$$ LANGUAGE plpgsql;
