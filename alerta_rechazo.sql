CREATE OR REPLACE FUNCTION alerta_rechazo() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO alerta (nrotarjeta, fecha, nrorechazo, codalerta, descripcion) VALUES (NEW.nrotarjeta, CURRENT_TIMESTAMP, NEW.nrorechazo, 0, NEW.motivo);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER alerta_rechazo_trigger
AFTER INSERT ON rechazo
FOR EACH ROW
EXECUTE PROCEDURE alerta_rechazo();
