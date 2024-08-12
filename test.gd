extends Node2D

func _ready():
	# Crear las fichas simuladas
	var token1 = Token.new()
	var token2 = Token.new()
	var token3 = Token.new()
	var token4 = Token.new()

	# Configurar que todas las fichas están en el cielo
	token1.in_heaven = true
	token2.in_heaven = true
	token3.in_heaven = true
	token4.in_heaven = true

	# Crear el jugador y asignar las fichas
	var player = Player.new()
	player.tokens = [token1, token2, token3, token4]

	# Ejecutar la lógica para verificar si ha ganado
	var winner = player.has_won()

	# Prueba: Verificar si la condición de ganador es verdadera
	assert(winner == true, "El jugador no ha ganado a pesar de tener todas las fichas en el cielo.")

	# Si pasa la prueba, imprimir el mensaje de éxito
	print("Prueba superada: El jugador amarillo gana cuando todas sus fichas están en el cielo.")
