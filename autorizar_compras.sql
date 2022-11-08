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

    -- Seleccion de fila completa de la tarjeta pasada por nrotarjeta.
    SELECT * INTO tarjeta_fila FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;
    
    -- Seleccion de fecha de vencimiento de la tarjeta pasada por nrotarjeta.
    SELECT CAST(validadesde AS TEXT) INTO fecha_de_vencimiento_text FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;

	--Asignacion a variables monto total de compras de tarjeta.
	--monto_total_compra_tarjeta_actual := SELECT SUM(monto) FROM compra c WHERE n_tarjeta = c.nrotarjeta;
	SELECT SUM(monto) INTO monto_total_compra_tarjeta_actual FROM compra c WHERE n_tarjeta = c.nrotarjeta and c.pagado = false;
   
    -- Conversion y Asignacion de fechas como type DATE
    fecha_actual := CURRENT_DATE;
	fecha_vencimiento := TO_DATE(fecha_de_vencimiento_text, 'YYYYMM');
	
    -- Control de la existencia de nrotarjeta pasada por parametro.
    IF NOT found then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo) 
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Tarjeta no valida o no vigente.');
    
        return false;

    -- Control de codigo de seguridad correcto
    ELSIF tarjeta_fila.codseguridad != cod_seg then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)  
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Codigo de seguridad invalido.');
        
        return false;
    
    -- Control de que la tarjeta no este vencida.
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
    ELSIF tarjeta_fila.limitecompra < monto_total_compras_tarjeta_actual then
        INSERT INTO rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Se supero el límite de la tarjeta.');
    
        return false;
    
    -- Paso controles entonces, se efectua la compra por autorizar y se inserta en la tabla correspondiente.
    ELSE
        INSERT INTO compra (nrotarjeta, nrocomercio, fecha, monto, pagado)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, false);

        return true;
    END IF;
END;
$$ LANGUAGE plpgsql;

