-- compra (nrooperacion serial, nrotarjeta char(16), nrocomercio int, fecha timestamp, monto decimal(7,2), pagado boolean);
-- tarjeta(nrotarjeta char(16), nrocliente int, validadesde char(6), validahasta char(6), codseguridad char(4), limitecompra decimal(8,2), estado char(10));

CREATE OR REPLACE FUNCTION autorizar_compra(n_tarjeta tarjeta.nrotarjeta%type, 
                                                cod_seg tarjeta.codseguridad%type,
                                                    n_comercio compra.nrocomercio%type,
                                                        monto_compra compra.monto%type) RETURN BOOLEAN as $$
DECLARE
    tarjeta_fila record;
    comercio_encontrado INT;
    fecha_de_vencimiento TEXT;
    fecha_actual TEXT;
BEGIN

    --calcular las compras pendientes
    -- Seleccion de fila completa de tarjeta
    SELECT * INTO tarjeta_fila FROM tarjeta t WHERE n_tarjeta = t.nrotarjeta;
    
    -- inserccion de la fecha hasta cuando es valida la tarjeta
    SELECT CAST(validadesde AS TEXT) INTO fecha_de_vencimiento FROM tarjeta_fila WHERE n_tarjeta = tarjeta_fila.nrotarjeta;

    --asignacion de fecha actual a variable como texto
    fecha_actual := CAST(CURRENT_DATE as TEXT);

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
    
    --Control de tarjeta que no este suspendida
    ELSIF tarjeta_fila.estado == 'suspendida' then
        INSERT INTO rechazo rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'La Tarjeta se encuentra suspendida.');
    
        return false;

    --Control de que la tarjeta no este vencida.
    ELSIF TO_DATE(fecha_de_vencimiento,'YYYYMM') == TO_DATE(fecha_actual,'YYYYMM') then
        INSERT INTO rechazo rechazo (nrotarjeta, nrocomercio, fecha, monto, motivo)
            VALUES (n_tarjeta, n_comercio, current_timestamp, monto_compra, 'Plazo de vigencia expirado.');
    
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