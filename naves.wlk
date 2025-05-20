class Nave{
	var velocidad = 0

	method velocidad() = velocidad

	method recibirAmenaza()

	method prepararExtra(){}

	method propulsar(){
		self.acelerar(20000)
	}

	method acelerar(cantidad){
		velocidad = (velocidad + cantidad).min(300000)
	}

	method preparar(){
		self.acelerar(15000)	
		self.prepararExtra()
	}

	method encontrarEnemigo(){
		self.recibirAmenaza()
		self.propulsar()
	}
}

class NaveDeCarga inherits Nave{
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000
	
	override method recibirAmenaza(){
		carga = 0
	}
}

class NaveDeResiduos inherits NaveDeCarga{
	var sellada = false
	
	method sellada() = sellada

	method sellar(){
		sellada = true
	}

	override method recibirAmenaza(){
		velocidad = 0
	}

	override method prepararExtra(){
		self.sellar()
	}
}

class NaveDePasajeros inherits Nave {
	var property alarma = false
	const cantidadDePasajeros = 0
	const cantidadDePersonal = 4
	const velocidadMaxima = 300000
	
	method tripulacion() = cantidadDePasajeros + cantidadDePersonal

	method velocidadMaximaLegal() = velocidadMaxima / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}
}

class NaveDeCombate inherits Nave{
	var property modo = reposo
	const property mensajesEmitidos = []

	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararExtra(){
		modo.preparar(self)
	}
}

class Modo{
	method invisible()

	method mensajeAmenaza()

	method mensajeAlPreparar()

	method pedirEmision(nave, mensaje){
		nave.emitirMensaje(mensaje)
	}

	method recibirAmenaza(nave){
		self.pedirEmision(nave, self.mensajeAmenaza())
	}

	method preparar(nave){
		self.pedirEmision(nave, self.mensajeAlPreparar())
	}
}

object reposo inherits Modo{
	const modoAlPreparar = ataque

	override method invisible() = false

	override method mensajeAmenaza() = "¡RETIRADA!"
	
	override method mensajeAlPreparar() = "Saliendo en misión"

	override method preparar(nave){
		super(nave)
		nave.modo(modoAlPreparar)
	}	      
}

object ataque inherits Modo {
	override method invisible() = true

	override method mensajeAmenaza() = "Enemigo encontrado"
	
	override method mensajeAlPreparar() = "Volviendo a la base"
}