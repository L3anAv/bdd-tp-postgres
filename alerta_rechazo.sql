CREATE OR REPLACE FUNCTION alerta_rechazo() RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO alerta VALUES (1, new.nrotarjeta, current_date, new.nrorechazo, 0, 'Alerta por rechazo.');
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER alerta_rechazo_trigger
AFTER INSERT ON rechazo
FOR EACH ROW
EXECUTE PROCEDURE alerta_rechazo();
