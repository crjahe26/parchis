extends Node2D

var current_player = 0
var tokens = []
@onready var dice = $Dice  # Cambia "$Dice" si usaste otro nombre para el nodo de dados

func _ready():
	tokens = [
		$TokenYellow1,
		$TokenYellow2,
		$TokenYellow3,
		$TokenYellow4,
		$TokenBlue1,
		$TokenBlue2,
		$TokenBlue3,
		$TokenBlue4,
		$TokenRed1,
		$TokenRed2,
		$TokenRed3,
		$TokenRed4,
		$TokenGreen1,
		$TokenGreen2,
		$TokenGreen3,
		$TokenGreen4
	]
	for token in tokens:
		token.connect("token_selected", Callable(self, "_on_token_selected"))

func next_turn():
	current_player = (current_player + 1) % tokens.size()

func roll_dice():
	var dice_roll = dice.roll()
	$DiceValueLabel2.text = "Dado: " + str(dice_roll)  # Ajusta esto si cambiaste el nombre del Label
	return dice_roll

func _on_token_selected(token):
	if token.color == get_current_player_color():
		var steps = roll_dice()
		token.move_steps(steps)
		next_turn()

func get_current_player_color():
	if current_player < 4:
		return "yellow"
	elif current_player < 8:
		return "blue"
	elif current_player < 12:
		return "red"
	else:
		return "green"
