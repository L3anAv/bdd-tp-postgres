--todas las compras del periodo + cabecera

--cabecera
--nroresumen:int,      (lo pongo yo)
--nombre:text,         (cliente)
--apellido:text,       (cliente)
--domicilio:text,      (cliente)
--nrotarjeta:char(16), (cliente)
--desde:date,          (cierre)
--hasta:date,          (cierre)
--vence:date,          (cierre)
--total:decimal(8,2)

--compra
--nrooperacion:int,
--nrotarjeta:char(16),
--nrocomercio:int,
--fecha:timestamp,     (si la fecha esta en el periodo, la uso para sumar su monto a aux_total)
--monto:decimal(7,2),
--pagado:boolean

CREATE OR REPLACE FUNCTION generar_resumen (nro_cliente cliente.nrocliente%TYPE, año INT, mes INT) RETURNS void AS $$

        DECLARE

	    aux_nroresumen INT := 0;
	    aux_nrolinea INT := 1;
	    aux_total INT := 0;
	    aux_cliente RECORD;
	    aux_compra RECORD;
	    aux_tarjeta RECORD;
	    aux_cierre RECORD;
	    aux_comercio RECORD;

        BEGIN

                INSERT INTO aux_cliente SELECT * FROM cliente WHERE nrocliente = nro_cliente; --guardo cliente en aux_cliente
	        --falta si cliente no existe...

                FOR aux_tarjeta IN SELECT * FROM tarjeta WHERE nrocliente = aux_nrocliente LOOP --recorro las tarjetas del cliente
        
		        aux_total := 0; --reinicio el total a pagar

		        SELECT * INTO aux_cierre FROM cierre c WHERE c.año = año AND c.mes = mes; --guardo cierre en aux_cierre

                        --creo cabecera
                        --falta aux_nroresumen y total = 0
                        INSERT INTO cabecera (nombre, apellido, domicilio, nrotarjeta, desde, hasta, vence, total)
                                VALUES (aux_cliente.nombre, aux_cliente.apellido, aux_cliente.domicilio, aux_tarjeta.nrotarjeta, aux_cierre.fechainicio, aux_cierre.fechacierre, aux_cierre.fechavto, aux_total);

                        --guardo nroresumen autogenerado en aux_nroresumen para usarlo en detalle
                        INSERT INTO aux_nroresumen SELECT nroresumen FROM cabecera WHERE nrotarjeta = aux_tarjeta.nrotarjeta
                                AND desde = aux_cierre.fechainicio AND hasta = aux_cierre.fechacierre;

                        FOR aux_compra IN SELECT * FROM compra WHERE nrotarjeta = aux_tarjeta.nrotarjeta AND fecha >= aux_cierre.fechainicio AND fecha <= aux_cierre.fechacierre AND pagado = false LOOP

                                SELECT DISTINCT * INTO aux_comercio FROM comercio WHERE nrocomercio = aux_compra.nrocomercio;

                                --falta aux_nroresumen y aux_nrolinea
                                INSERT INTO detalle (nroresumen, nrolinea, fecha, nombre_comercio, monto)
                                        VALUES (aux_nroresumen, aux_nrolinea, aux_compra.fecha, aux_comercio.nombre, aux_compra.monto);
			        aux_nrolinea := aux_nrolinea + 1;
                                aux_total := aux_total + aux_compra.monto;
                                UPDATE compra SET pagado = true WHERE nrooperacion = aux_compra.nrooperacion;
                        END LOOP;

                        UPDATE cabecera SET total = aux_total WHERE nrotarjeta = aux_tarjeta.nrotarjeta;
                        
                END LOOP;
END;
$$ LANGUAGE plpgsql;