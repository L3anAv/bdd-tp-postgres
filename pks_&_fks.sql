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

-- PK’s Drops

ALTER TABLE cliente DROP CONSTRAINT cliente_pk;
ALTER TABLE tarjeta DROP CONSTRAINT tarjeta_pk;
ALTER TABLE comercio DROP CONSTRAINT comercio_pk;
ALTER TABLE compra DROP CONSTRAINT compra_pk;
ALTER TABLE rechazo DROP CONSTRAINT rechazo_pk;
ALTER TABLE cierre DROP CONSTRAINT cierre_pk;
ALTER TABLE cabecera DROP CONSTRAINT cabecera_pk;
ALTER TABLE detalle DROP CONSTRAINT detalle_pk;
ALTER TABLE alerta DROP CONSTRAINT alerta_pk;

-- FK’s Drops

ALTER TABLE tarjeta DROP CONSTRAINT tarjeta_nrocliente_fk;
ALTER TABLE compra DROP CONSTRAINT compra_nrotarjeta_fk;
ALTER TABLE compra DROP CONSTRAINT compra_nrocomercio_fk;
ALTER TABLE rechazo DROP CONSTRAINT rechazo_nrotarjeta_fk;
ALTER TABLE rechazo DROP CONSTRAINT rechazo_nrocomercio_fk;
ALTER TABLE cabecera DROP CONSTRAINT cabecera_nrotarjeta_fk;
ALTER TABLE alerta DROP CONSTRAINT alerta_nrotarjeta_fk;
ALTER TABLE alerta DROP CONSTRAINT alerta_nrorechazo_fk;
ALTER TABLE consumo DROP CONSTRAINT consumo_nrotarjeta_fk;
ALTER TABLE consumo DROP CONSTRAINT consumo_nrocomercio_fk;