DROP DATABASE IF EXISTS tarjetas;
CREATE DATABASE tarjetas;
\c tarjetas
CREATE TABLE cliente (nrocliente SERIAL, nombre TEXT, apellido TEXT, domicilio TEXT, telefono CHAR(12));
CREATE TABLE tarjeta (nrotarjeta CHAR(16), nrocliente INT, validadesde CHAR(6), validahasta CHAR(6), codseguridad CHAR(4), limitecompra DECIMAL(8,2), estado CHAR(10));
CREATE TABLE comercio (nrocomercio SERIAL, nombre TEXT, domicilio TEXT, codigopostal CHAR(8), telefono CHAR(12));
CREATE TABLE compra (nrooperacion SERIAL, nrotarjeta CHAR(16), nrocomercio INT, fecha TIMESTAMP, monto DECIMAL(7,2), pagado BOOLEAN);
CREATE TABLE rechazo (nrorechazo SERIAL, nrotarjeta CHAR(16), nrocomercio INT, fecha TIMESTAMP, monto DECIMAL(7,2), motivo TEXT);
CREATE TABLE cierre (año INT, mes INT, terminacion INT, fechainicio DATE, fechacierre DATE, fechavto DATE);
CREATE TABLE cabecera (nroresumen INT, nombre TEXT, apellido TEXT, domicilio TEXT, nrotarjeta CHAR(16), desde DATE, hasta DATE, vence DATE, total DECIMAL(8,2));
CREATE TABLE detalle (nroresumen INT, nrolinea INT, fecha DATE, nombrecomercio TEXT, monto DECIMAL(7,2));
CREATE TABLE alerta (nroalerta SERIAL, nrotarjeta CHAR(16), fecha TIMESTAMP, nrorechazo INT, codalerta INT, descripcion TEXT);
CREATE TABLE consumo (nrotarjeta CHAR(16), codseguridad CHAR(4), nrocomercio INT, monto DECIMAL(7,2));

-- PK’s

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY (nrocliente);
ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_pk PRIMARY KEY (nrotarjeta);
ALTER TABLE comercio ADD CONSTRAINT comercio_pk PRIMARY KEY (nrocomercio);
ALTER TABLE compra ADD CONSTRAINT compra_pk PRIMARY KEY (nrooperacion);
ALTER TABLE rechazo ADD CONSTRAINT rechazo_pk PRIMARY KEY (nrorechazo);
ALTER TABLE cierre ADD CONSTRAINT cierre_pk PRIMARY KEY (año, mes, terminacion);
ALTER TABLE cabecera ADD CONSTRAINT cabecera_pk PRIMARY KEY (nroresumen);
ALTER TABLE detalle ADD CONSTRAINT detalle_pk PRIMARY KEY (nroresumen, nrolinea);
ALTER TABLE alerta ADD CONSTRAINT alerta_pk PRIMARY KEY (nroalerta);
ALTER TABLE consumo ADD CONSTRAINT consumo_pk PRIMARY KEY (nrotarjeta, nrocomercio);

-- FK’s

ALTER TABLE tarjeta ADD CONSTRAINT tarjeta_nrocliente_fk FOREIGN KEY (nrocliente) REFERENCES cliente (nrocliente);
ALTER TABLE compra ADD CONSTRAINT compra_nrotarjeta_fk FOREIGN KEY (nrotarjeta) REFERENCES tarjeta (nrotarjeta);
ALTER TABLE compra ADD CONSTRAINT compra_nrocomercio_fk FOREIGN KEY (nrocomercio) REFERENCES comercio (nrocomercio);
ALTER TABLE rechazo ADD CONSTRAINT rechazo_nrotarjeta_fk FOREIGN KEY (nrotarjeta) REFERENCES tarjeta (nrotarjeta);
ALTER TABLE rechazo ADD CONSTRAINT rechazo_nrocomercio_fk FOREIGN KEY (nrocomercio) REFERENCES comercio (nrocomercio);
ALTER TABLE cabecera ADD CONSTRAINT cabecera_nrotarjeta_fk FOREIGN KEY (nrotarjeta) REFERENCES tarjeta (nrotarjeta);
ALTER TABLE alerta ADD CONSTRAINT alerta_nrotarjeta_fk FOREIGN KEY (nrotarjeta) REFERENCES tarjeta (nrotarjeta);
ALTER TABLE alerta ADD CONSTRAINT alerta_nrorechazo_fk FOREIGN KEY (nrorechazo) REFERENCES rechazo (nrorechazo);
ALTER TABLE consumo ADD CONSTRAINT consumo_nrotarjeta_fk FOREIGN KEY (nrotarjeta) REFERENCES tarjeta (nrotarjeta);
ALTER TABLE consumo ADD CONSTRAINT consumo_nrocomercio_fk FOREIGN KEY (nrocomercio) REFERENCES comercio (nrocomercio);

-- Clientes

INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Matias', 'Avila', '9 de Julio 2302', '541112321232');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Giannina', 'Perez', 'Panamericana Km 36.5', '541145678970');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Lucas', 'Prieto', 'Av. Pres. Arturo Umberto Illia 3770', '541142335678');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Guadalupe', 'Torres', 'Av. Victorica 1128', '541134521789');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Tomas', 'Gutierrez', 'Formosa y Ruta 52', '541167789012');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Juan', 'Ugarte', 'Quevedo 3365', '541146578974');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Sergio', 'Messi', 'Av. Del Libertador 6820', '541156920932');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Santiago', 'Pereyra', 'Paraná 3745', '541154648972');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Karina', 'Castan', 'San Martín 546', '541176853412');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Emiliano', 'Ayala', 'Sarmiento 2157', '541156748921');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Fabian', 'Moreno', 'Juan Julian Lastra 2400', '541145769276');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Jorge', 'Peron', 'Av Nestor C. Kirchner 1142', '541125678970');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Federico', 'Santillan', 'Josiah Williams 209', '541178929283');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Sebastian', 'Rodriguez', 'Perito Moreno 1460', '541176526341');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Camila', 'Martin', 'San Martín 800', '541154327801');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Tania', 'Rojo', 'Av. España 309', '541134679086');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Belen', 'Aristimuño', 'Av. Libertad 254', '541197367361');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Morena', 'Dominguez', 'Av. Sáenz Peña 318', '541121340968');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Paola', 'Tugas', 'Enrique Bodereau 7571', '541197656291');
INSERT INTO cliente (nombre, apellido, domicilio, telefono) VALUES ('Paulo', 'Gomez', 'Recta Martinoli 8357', '541187561264');

-- Comercios

INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Ferreteria El Cosito', 'Cervantes 565','C1425EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Carniceria La Vaca Feliz', 'Gral. Guemes 897','B8225EID','541199999999');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Bar El Obrero', 'Donado 65','E6325EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Merceria Doña Tita', 'Pres. Juan Domingo Perón 4739','F3325EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Farmacia Balcarce', 'Paraná 3822','F6721EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Supermecado Los 3 Hermanos', 'Antonio Saenz 2041','B6721EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Hotel San Carlos', 'Av. Ing Agustín Rocca 249','G8902EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Dietetica El Obeso', 'Conquista Del Desierto 230','H9012EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Kiosco La Esquina', 'Dr. Salvador Sallares 63','F5462EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Verduleria Don Pedro', 'Bernardo De Monteagudo 3351','A7810EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Panaderia La Ponderosa', 'Brig. Gral. Juan M. De Rosas 14446','G2091EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Veterinaria Cura Bicho', 'Av. Eva Duarte de Peron 1474','H5674EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Tienda de Ropa La Gastadera', 'Hipólito Yrigoyen 1807','C4512EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Vidrieria El Reflejo', 'Av Luro 5975','F3241EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Gomeria La Rueda Feliz', '9 De Julio 1185','E4312EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Mecanica Austral', 'Calle 8 788','G3212EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Lavadero Blanca', 'Calle 12 esq. 58 Nº 1249','C6786EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Colchones Dulce Sueños', 'Sarmiento 2685','C2341EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Salon de Fiestas Wonka', 'Catamarca 1865','F0443EID','541100000000');
INSERT INTO comercio (nombre, domicilio, codigopostal, telefono) VALUES ('Restaurant Ratatouille', 'Bartolomé Mitre 2642','G3245EID','541100000000');

-- Tarjetas

INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('9320584378172604', 1, '201106', '201406', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('4982394782623736', 2, '202008', '202308', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('5129043812284623', 3, '202203', '202503', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('1294382965767449', 4, '201912', '202212', '8246', 40000, 'suspendida');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('9293437257327169', 5, '202109', '202409', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('5827624652643290', 6, '202211', '202511', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('3928217404085943', 7, '202212', '202512', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('1982747364536562', 8, '201301', '201601', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('9012348282748326', 9, '202010', '202310', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('8274236578326572', 10, '201911', '202211', '8246', 40000, 'suspendida');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('8324732653627823', 11, '202204', '202504', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('7632462483439834', 12, '201212', '201512', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('7216435365643723', 13, '200112', '200412', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('3624376458982394', 14, '202007', '202307', '8246', 40000, 'suspendida');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('6347467826428439', 15, '202006', '202306', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('5923892848377829', 16, '201003', '201303', '8246', 40000, 'suspendida');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('3784736427463790', 17, '202003', '202303', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('3209340294208483', 18, '202108', '202408', '8246', 40000, 'suspendida');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('2743472943783934', 19, '202109', '202409', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('8437284736756736', 19, '200202', '200502', '8246', 40000, 'anulada');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('3464536272389793', 20, '202201', '202501', '8246', 40000, 'vigente');
INSERT INTO tarjeta (nrotarjeta, nrocliente, validadesde, validahasta, codseguridad, limitecompra, estado) VALUES ('1273672467364703', 20, '200506', '200806', '8246', 40000, 'anulada');

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
