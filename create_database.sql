DROP DATABASE IF EXISTS tarjetas;
CREATE DATABASE tarjetas;
\c tarjetas

CREATE TABLE cliente (nrocliente int, nombre text, apellido text, domicilio text, telefono char(12));
CREATE TABLE tarjeta (nrotarjeta char(16), nrocliente int, validadesde char(6), validahasta char(6), codseguridad char(4), limitecompra decimal(8,2), estado char(10));
CREATE TABLE comercio (nrocomercio int, nombre text, domicilio text, codigopostal char(8), telefono char(12));
CREATE TABLE compra (nrooperacion int, nrotarjeta char(16), nrocomercio int, fecha timestamp, monto decimal(7,2), pagado boolean);
CREATE TABLE rechazo (nrorechazo int, nrotarjeta char(16), nrocomercio int, fecha timestamp, monto decimal(7,2), motivo text);
CREATE TABLE cierre (año int, mes int, terminacion int, fechainicio date, fechacierre date, fechavto date);
CREATE TABLE cabecera (nroresumen int, nombre text, apellido text, domicilio text, nrotarjeta char(16), desde date, hasta date, vence date, total decimal(8,2));
CREATE TABLE detalle (nroresumen int, nrolinea int, fecha date, nombrecomercio text, monto decimal(7,2));
CREATE TABLE alerta (nroalerta int, nrotarjeta char(16), fecha timestamp, nrorechazo int, codalerta int, descripcion text);
CREATE TABLE consumo (nrotarjeta char(16), codseguridad char(4), nrocomercio int, monto decimal(7,2));
