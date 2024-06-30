extends Node2D

var current_player = 0
var tokens = []

func _ready():
	tokens = [
		$Token1,  # Cambia estos nombres según tus instancias
		$Token2
	]

func next_turn():
	current_player = (current_player + 1) % tokens.size()

func roll_dice():
	var dice_value = randi() % 6 + 1  # Devuelve un número entre 1 y 6
	$DiceValueLabel.text = "Dado: " + str(dice_value)  # Muestra el valor en el label
	return dice_value

func on_token_selected(token):
	var steps = roll_dice()
	token.move_steps(steps)
	next_turn()
