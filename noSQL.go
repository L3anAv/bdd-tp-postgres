package main

import (
	"encoding/json"
	bolt "go.etcd.io/bbolt"
	"fmt"
	"log"
)

type Cliente struct {
	NroCliente int
	Nombre     string
	Apellido   string
	Domicilio  string
	Telefono   string
}

type Tarjeta struct {
	NroTarjeta   string
	NroCliente   int
	ValidaDesde  string
	ValidaHasta  string
	CodSeguridad int
	LimiteCompra float64
	Estado       string
}

type Comercio struct {
	NroComercio  int
	Nombre       string
	Domicilio    string
	CodigoPostal int
	Telefono     string
}

type Compra struct {
	NroOperacion int
	NroTarjeta   string
	NroComercio  int
	Fecha        string
	Monto        float64
	Pagado       bool
}

var db *bolt.DB
var err error
var opcion int = 0
var Menu string
var clientes []Cliente
var tarjetas []Tarjeta
var comercios []Comercio
var compras []Compra

func main() {

	Menu := 
	`% Bienvenido % Opciones de acciones para realizar:
			
		[1]. Crear Base de datos de Tarjetas. 
		[2]. Insertar datos de clientes.
		[3]. Insertar datos de tarjetas.
		[4]. Insertar datos de comercios.
		[5]. Insertar datos de compras.
		[6]. SALIR.`

		fmt.Print(Menu)
		fmt.Print("Ingrese el número de opción a realizar: ")
		fmt.Scanf("%d", &opcion)
		fmt.Print("Operación solicitada: ", opcion)
		fmt.Print("\n")
		
	switch opcion{
			case 1:
				fmt.Print("Creando Base de datos... \n")
				createDatabase()
				fmt.Print("Base de datos creada! \n")
			case 2:
				fmt.Print("Insertando datos de clientes. \n")
				// Funcion insertar clientes
				fmt.Print("Datos de clientes insertados! \n")
			case 3:
				fmt.Print("Insertando datos de tarjetas. \n")
				// Funcion insertar tarjetas
				fmt.Print("Datos de tarjetas insertados! \n")
			case 4:
				fmt.Print("Insertando datos de comercios. \n")
				// Funcion insertar comercios
				fmt.Print("Datos de comercios insertados! \n")
			case 5:
				fmt.Print("Insertando datos de compras. \n")
				// Funcion insertar compras
				fmt.Print("Datos de compras insertados! \n")
			case 6:
				os.Exit(1)
	}
}

func main() {
	fillArrays()

	for opcion != 6 {

		fmt.Print("Opciones de acciones para realizar\n")
		fmt.Print("1 = Crear base de datos Tarjetas\n")
		fmt.Print("2 = Insertar datos de los clientes\n")
		fmt.Print("3 = Insertar datos de las tarjetas\n")
		fmt.Print("4 = Insertar datos de los comercios\n")
		fmt.Print("5 = Insertar datos de las compras\n")
		fmt.Print("6 = Terminar y salir\n")

		fmt.Print("\nElija una opcion: ")
		fmt.Scanf("%d", &opcion)
		fmt.Print("opcion seleccionada: ", opcion)
		fmt.Print("\n")

		if opcion == 1 {
			createDatabase()
		}

		if opcion == 2 {
			insertClientes()
		}

		if opcion == 3 {
			insertTarjetas()
		}

		if opcion == 4 {
			insertComercios()
		}

		if opcion == 5 {
			insertCompras()
		}

		if opcion == 6 {
			fmt.Print("\n SALIENDO...\n")
		}
	}
}

func fillArrays() {
	clientes = append(clientes, Cliente{4, "Guadalupe", "Torres", "Av. Victorica 1128", "541134521789"})
	clientes = append(clientes, Cliente{5, "Tomas", "Gutierrez", "Formosa y Ruta 52", "541167789012"})
	clientes = append(clientes, Cliente{6, "Juan", "Ugarte", "Quevedo 3365", "541146578974"})
	tarjetas = append(tarjetas, Tarjeta{"1294382965767449", 4, "201912", "202212", "2364", 10500, "suspendida"})
	tarjetas = append(tarjetas, Tarjeta{"9293437257327169", 5, "202109", "202409", "937", 67000, "anulada"})
	tarjetas = append(tarjetas, Tarjeta{"5827624652643290", 6, "202211", "202511", "8246", 8000, "vigente"})
	comercios = append(comercios, Comercio{1, "Ferreteria El Cosito", "Cervantes 565","C1425EID","541165849035"})
	comercios = append(comercios, Comercio{2, "Carniceria La Vaca Feliz", "Gral. Guemes 897","C1425EID","541199999999"})
	comercios = append(comercios, Comercio{3, "Bar El Obrero", "Donado 65","E6325EID","541174392057"})
	compras = append(compras, Compra{1, "1294382965767449", 1, "2022-09-11", 2500, false})
	compras = append(compras, Compra{2, "9293437257327169", 2, "2022-06-20", 50250, false})
	compras = append(compras, Compra{3, "5827624652643290", 2, "2022-08-15", 7800, false})
}

func createDatabase() {
	db, err = bolt.Open("tarjetas.db", 0600, nil)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
}