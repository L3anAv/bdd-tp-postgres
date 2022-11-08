-- compra (nrooperacion serial, nrotarjeta char(16), nrocomercio int, fecha timestamp, monto decimal(7,2), pagado boolean);
-- tarjeta(nrotarjeta char(16), nrocliente int, validadesde char(6), validahasta char(6), codseguridad char(4), limitecompra decimal(8,2), estado char(10));

CREATE OR REPLACE FUNCTION autorizar_compra(n_tarjeta tarjeta.nrotarjeta%type,
                                                cod_seg tarjeta.codseguridad%type,
                                                    n_comercio compra.nrocomercio%type,
                                                        monto_compra compra.monto%type) RETURNS boolean as $$
DECLARE
    fecha_actual DATE;
    tarjeta_fila record;
    fecha_vencimiento DATE;
    comercio_encontrado INT;
    fecha_de_vencimiento_text TEXT;   
BEGIN

    --calcular las compras pendientes
    -- Seleccion de fila completa de tarjeta
    SELECT * INTO tarjeta_fila FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;
    
    -- inserccion de la fecha hasta cuando es valida la tarjeta
    SELECT CAST(validadesde AS TEXT) INTO fecha_de_vencimiento_text FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;

    --asignacion de fecha actual a variable como texto
    fecha_actual := CURRENT_DATE;
	fecha_vencimiento := TO_DATE(fecha_de_vencimiento_text, 'YYYYMM');
	
    --Control de la tarjeta pasada por parametro
    IF NOT found then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo) 
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Tarjeta no valida o no vigente.');
    
        return false;

    --Control de codigo de seguridad correcto
    ELSIF tarjeta_fila.codseguridad != cod_seg then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)  
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Codigo de seguridad invalido.');
        
        return false;
    
    --Control de que la tarjeta no este vencida.
    ELSIF fecha_actual > fecha_vencimiento then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Plazo de vigencia expirado.');
    
        return false;

    --Control de tarjeta que no este suspendida
    ELSIF tarjeta_fila.estado == 'suspendida' then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'La Tarjeta se encuentra suspendida.');
    
        return false;

    --Control de monto que no supere el limite permitido de la tarjeta.
    -- compra (nrooperacion INT, nrotarjeta CHAR(16), nrocomercio INT, fecha TIMESTAMP, monto DECIMAL(7,2), pagado BOOLEAN);
    ELSE
        INSERT INTO compra (nrotarjeta, nrocomercio, fecha, monto, pagado)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, false);

        return true;
    END IF;
END;
$$ LANGUAGE plpgsql;

