extends Node2D

onready var token_scene = preload("res://Scenes/token.tscn")

var paths = [
	[ $Board/Casilla1, $Board/Casilla2, $Board/Casilla3],  # Ruta para el primer color
	[ $Board/Casilla14, $Board/Casilla15, $Board/Casilla16]  # Ruta para el segundo color
]

var current_player = 0  # Índice del jugador actual

func _ready():
	# Instanciar fichas y asignar rutas
	for i in range(2):  # Por ejemplo, 2 rutas definidas
		var token = token_scene.instance()
		token.token_color = i
		token.path = paths[i]
		token.update_position(token.path[0].position)
		add_child(token)
