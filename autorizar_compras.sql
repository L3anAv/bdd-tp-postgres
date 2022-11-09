CREATE OR REPLACE FUNCTION autorizar_compra(n_tarjeta tarjeta.nrotarjeta%type,
                                                cod_seg tarjeta.codseguridad%type,
                                                    n_comercio compra.nrocomercio%type,
                                                        monto_compra compra.monto%type) RETURNS boolean as $$
DECLARE
    tarjeta_fila record; -- Fila de tarjeta de nrodetarjeta pasada por parametro
    fecha_actual DATE;   -- Fecha del dia actual.
    fecha_vencimiento DATE; -- Fecha de tope de vencimiento de la tarjeta pasada por parametro.
    comercio_encontrado INT; -- numero de comercio pasado, que exista.
    fecha_de_vencimiento_text TEXT;  -- Donde guardo la fecha de tarjeta de vencimiento como texto.
	monto_total_compras_tarjeta_actual compra.monto%type; -- Monto total de compras actuales de la tarjeta pasada por parametro.
BEGIN

    -- Seleccion de fila completa de la tarjeta filtrado por nrotarjeta.
    SELECT * INTO tarjeta_fila FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;
    
    -- Control de la existencia de nrotarjeta pasada por parametro.
    IF NOT found then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo) 
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Tarjeta no valida o no vigente.');
    
        return false;

    -- Seleccion de fecha de vencimiento de la tarjeta pasada por nrotarjeta pasado por parametro.
    SELECT CAST(validadesde AS TEXT) INTO fecha_de_vencimiento_text FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;

	-- Asignacion a variable el valor de monto total de compras realizadas por la tarjeta pasada por parametro.
	SELECT SUM(monto) INTO monto_total_compras_tarjeta_actual FROM compra c WHERE n_tarjeta = c.nrotarjeta and c.pagado = false;
   
    -- Conversion y Asignacion de fechas como type DATE
    fecha_actual := CURRENT_DATE;
	fecha_vencimiento := TO_DATE(fecha_de_vencimiento_text, 'YYYYMM');

    -- Control de codigo de seguridad correcto
    ELSIF tarjeta_fila.codseguridad != cod_seg then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)  
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Codigo de seguridad invalido.');
        
        return false;
    
    --Control que el monto total de compras de la tarjeta no supere el limite permitido de la misma.
    ELSIF monto_total_compras_tarjeta_actual >= tarjeta_fila.limitecompra then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Se supero el límite de la tarjeta.');

        return false;
    
    -- Control de que la tarjeta no este vencida.
    ELSIF fecha_vencimiento > fecha_actual then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Plazo de vigencia expirado.');
    
        return false;

    --Control de tarjeta que no este suspendida.
    ELSIF tarjeta_fila.estado = 'suspendida' then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'La Tarjeta se encuentra suspendida.');
    
        return false;
    
    -- Si pasa todos los controles, se efectua la compra por autorizar y se inserta en la tabla correspondiente retornando.
    ELSE
        INSERT INTO compra (nrotarjeta, nrocomercio, fecha, monto, pagado)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, false);

        return true;
    END IF;
END;
$$ LANGUAGE plpgsql;