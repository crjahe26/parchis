extends Area2D

var position_index = 0  # Índice de la posición actual en la ruta
var path = []  # Ruta que seguirá la ficha
var token_color = 0  # Color o identificador del jugador

func _ready():
	update_position(path[position_index].position)

func update_position(position):
	self.position = position

func move_token(steps):
	position_index += steps
	if position_index < len(path):
		update_position(path[position_index].position)
	else:
		# Manejar cuando la ficha llega al final de la ruta
		position_index = len(path) - 1
