package main

import (
	"database/sql"
	"fmt"
)

type Cliente struct {
	Nrocliente int,
	Nombre string,
	Apellido string,
	Domicilio string,
	Telefono string
}

type Tarjeta struct {
	Nrotarjeta string,
	Nrocliente int,
	Validadesde string,
	Validahasta string,
	Codseguridad string,
	Limitecompra float64,
	Estado string
}

type Comercio struct {
	Nrocomercio int,
	Nombre string,
	Domicilio string,
	Codigopostal string,
	Telefono string
}

type Compra struct {
	Nrooperacion int,
	Nrotarjeta string,
	Nrocomercio int,
	Fecha string,
	Monto float64,
	Pagado bool
}


type Rechazo struct {
	Nrorechazo int,
	Nrotarjeta string,
	Nrocomercio int,
	Fecha string,
	Monto float64,
	Motivo string
}

type Cierre struct {
	Año int,
	Mes int,
	Terminacion int,
	Fechainicio string,
	Fechacierre string,
	Fechavto string
}

type Cabecera struct {
	Nroresumen int,
	Nombre string,
	Apellido string,
	Domicilio string,
	Nrotarjeta string,
	Desde string,
	Hasta string,
	Vence string,
	Total float64
}

type Detalle struct {
	Nroresumen:int,
	Nrolinea:int,
	Fecha string,
	Nombrecomercio string,
	Monto float64;
}

type Alerta struct {
	Nroalerta int,
	Nrotarjeta string,
	Fecha string,
	Nrorechazo int,
	Codalerta int,
	Descripcion string
}

consumo struct {
	Nrotarjeta string,
	Codseguridad string,
	Nrocomercio int,
	Monto float64;
}
	