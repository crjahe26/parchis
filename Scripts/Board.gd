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
		var dice_values = dice.get_dice_values()
		var dice_value1 = dice_values[0]
		var dice_value2 = dice_values[1]
		print("dice_values: ", dice_values, " dice_value1: ", dice_value1, " dice_value2: ", dice_value2)
		if (dice_value1 == 1 and dice_value2 == 6) or (dice_value1 == 6 and dice_value2 == 1):
			release_all_tokens_from_jail(token.color)
		elif dice_value1 == dice_value2:
			handle_double_roll(token, steps)
		else:
			handle_regular_roll(token, steps)
		next_turn()

func release_all_tokens_from_jail(color):
	for token in tokens:
		if token.color == color and token.is_in_jail():
			token.release_from_jail()

func handle_double_roll(token, steps):
	if token.is_in_jail():
		token.release_from_jail()
	else:
		token.move_steps(steps)

func handle_regular_roll(token, steps):
	if token.is_in_jail():
		# Manejar el caso cuando la ficha está en la cárcel
		# Si está en la cárcel, el jugador no puede mover la ficha
		next_turn()
		return
	else:
		token.move_steps(steps)

func get_current_player_color():
	if current_player < 4:
		return "yellow"
	elif current_player < 8:
		return "blue"
	elif current_player < 12:
		return "red"
	else:
		return "green"
