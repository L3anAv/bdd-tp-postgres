package main

import (
	"encoding/json"
	bolt "go.etcd.io/bbolt"
	"fmt"
	"log"
	"os"
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
`% Bienvenido % 
  ~ Opciones de acciones para realizar:
		
	[1]. Crear base NoSQL de datos: [Tarjetas]. 
	[2]. Rellenar arreglos de clientes, tarjetas, comercios, y compras. 
	[3]. Insertar datos de los clientes en DB.
	[4]. Insertar datos de las tarjetas en DB.
	[5]. Insertar datos de los comercios en DB.
	[6]. Insertar datos de las compras en DB.
	[7]. SALIR. 

`
	for opcion != 9 {
		
		fmt.Print(Menu,"\n")
		fmt.Print("Ingrese el número de opción a realizar: ")
		fmt.Scanf("%d", &opcion)
		fmt.Print("Operación solicitada: ", opcion)
		fmt.Print("\n")
		if(opcion <= 0 || opcion >= 8){ 
			fmt.Print("Ingrese una opcion valida. \n")
			os.Exit(0) 
		}
		
	switch opcion{
		case 1:
			fmt.Print("Creando base... \n")
			crearbaseDeDatos()
			fmt.Print("Base de datos creada. \n")
		case 2:
			fmt.Print("Insertando info en arrays... \n")
			rellenarArraysConDatos()
			fmt.Print("Datos ingresandos en arrays. \n")
		case 3:

		case 4:

		case 5:

		case 6:

		case 7:
			os.Exit(0)
		}
	}

}

func crearbaseDeDatos() {
	db, err = bolt.Open("tarjetas.db", 0600, nil)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
}

func rellenarArraysConDatos() {
	
	// clientes
	clientes = append(clientes, Cliente{4, "Guadalupe", "Torres", "Av. Victorica 1128", "541134521789"})
	clientes = append(clientes, Cliente{5, "Tomas", "Gutierrez", "Formosa y Ruta 52", "541167789012"})
	clientes = append(clientes, Cliente{6, "Juan", "Ugarte", "Quevedo 3365", "541146578974"})
	
	// tarjetas
	tarjetas = append(tarjetas, Tarjeta{"1294382965767449", 4, "201912", "202212", "2364", 10500, "suspendida"})
	tarjetas = append(tarjetas, Tarjeta{"9293437257327169", 5, "202109", "202409", "937", 67000, "anulada"})
	tarjetas = append(tarjetas, Tarjeta{"5827624652643290", 6, "202211", "202511", "8246", 8000, "vigente"})
	
	// comercios
	comercios = append(comercios, Comercio{1, "Ferreteria El Cosito", "Cervantes 565","C1425EID","541165849035"})
	comercios = append(comercios, Comercio{2, "Carniceria La Vaca Feliz", "Gral. Guemes 897","C1425EID","541199999999"})
	comercios = append(comercios, Comercio{3, "Bar El Obrero", "Donado 65","E6325EID","541174392057"})
	
	// compras
	compras = append(compras, Compra{1, "1294382965767449", 1, "2022-09-11", 2500, false})
	compras = append(compras, Compra{2, "9293437257327169", 2, "2022-06-20", 50250, false})
	compras = append(compras, Compra{3, "5827624652643290", 2, "2022-08-15", 7800, false})
}

func insertarClientes(){

	for _, cliente := range Clientes{

		//Conversion a json data de cliente
		data, error := json.Marshall(cliente)
		if error != nil { // Control de error
			log.Fatal(error)
		}
		
		//Insertar en DB cada cliente.
		createUpdateBucket(db, "cliente", []byte(strconv.Itoa(cliente.NroCliente)), data) //Insertar en bucket creado o existente.
		
		//Leer el resultado insertado para mostrar.
		resultado, error := leerFilaDeBucket(db, "cliente", []byte(strconv.Itoa(cliente.NroCliente))) //Extrayendolo del bucket con modo lectura
		if error != nil{ // Control de error
			log.Fatal(error)
		}
		
		fmt.Print("\n%s\n", resultado)
	}

	fmt.Print("Inserccion de datos de clientes terminada. \n") // Mensaje final de operacion terminada.

}


/* Funciones aux para insertar y mostrar datos insertados */

func createUpdateBucket(db *bolt.DB, bucketName string, clave []byte, valor []byte) error {
	//Abre transaccion de escritura en la DB
	tx, err := db.Begin(true)
	if err != nil{ // Control de error de apertura de transaccion de escritura
		return err
	}
	// Rollback en caso de salir antes (no realiza el update)
	defer tx.Rollback()

	// Creo el bucket si no existe, y si existe lo llamo o cosumo
	b, _ := tx.createBucketIfNotExists([]byte(bucketName))

	// Inserto el par clave valor pasado por parametro y lo ingreso en el bucket
	err = b.Put(clave, valor)
	if err != nil { // Control de error de ingreso de datos
		return err
	}

	//Cierra transaccion. Commit los cambios.
	if err != tx.Commit(); err != nil {
		return err // Control de error en commit
	}

	return nil
}

func leerFilaDeBucket(db *bolt.DB, bucketName string, key []byte) ([]byte, error) {
	//Donde guardamos lo obtenido
	var buffer []byte

	//Abrimos una transaccion de lectura
	error := db.View(func(tx *bolt.Tx) error { // obtenemos y en tal caso devolvemos el error
		b := tx.Bucket([]byte(bucketName)) // Buscamos el bucket
		buffer := b.Get(key) // Obtenemos datos atravez del id
		return nil
	})

	return buffer, error //Retornamos buffer
}