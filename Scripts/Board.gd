extends Node2D

var current_player = 0
var tokens = []
@onready var dice = $Dice
@onready var dice_value_label = $DiceValueLabel2
@onready var turn_label = $TurnLabel
@onready var confirmation_dialog = $ConfirmationDialog

var pending_steps = 0
var pending_token = null
var pending_target_token = null
var remaining_steps = 0

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

	# Conectar los eventos del diálogo de confirmación
	confirmation_dialog.connect("confirmed", Callable(self, "_on_ConfirmationDialog_confirmed"))
	confirmation_dialog.connect("canceled", Callable(self, "_on_ConfirmationDialog_canceled"))

	update_turn_label()

func next_turn():
	check_for_winner()
	current_player = (current_player + 1) % 4
	#current_player = (current_player)
	update_turn_label()

func roll_dice():
	var dice_roll = dice.roll()
	dice_value_label.text = "Dado: " + str(dice_roll)
	return dice_roll

func _on_token_selected(token):
	if token.color == get_current_player_color():
		var steps = roll_dice()
		var dice_values = dice.get_dice_values()
		var dice_value1 = dice_values[0]
		var dice_value2 = dice_values[1]
		print("dice_values: ", dice_values, " dice_value1: ", dice_value1, " dice_value2: ", dice_value2)
		#if (dice_value1 == 1 and dice_value2 == 6) or (dice_value1 == 6 and dice_value2 == 1):
		#	release_token_from_jail(token.color)
		if dice_value1 == dice_value2:
			handle_double_roll(token, steps)
		else:
			handle_regular_roll(token, steps)
		next_turn()

func release_token_from_jail(color):
	for token in tokens:
		if token.color == color and token.is_in_jail():
			token.release_from_jail()
			break

func handle_double_roll(token, steps):
	if token.is_in_jail():
		token.release_from_jail()
	else:
		handle_regular_roll(token, steps)

func handle_regular_roll(token, steps):
	if token.is_in_jail():
		return
	else:
		var target_position = calculate_target_position(token, steps)
		if is_safe_square(target_position):
			token.move_steps(steps)
		else:
			var target_token = get_token_at_position(target_position)
			if target_token != null and target_token.color != token.color:
				ask_to_eat_token(token, target_token, steps)
			else:
				token.move_steps(steps)

func calculate_target_position(token, steps):
	print("calculating target position")
	var new_position = token.current_position + steps
	print("new_position is: ", new_position)
	var max_position = get_max_position_for_color(token.color)
	#if new_position > max_position:
	#	new_position -= max_position + 1 Esto evita que se pueda comer las fichas porque en general al ir dando la vuelta al tablero el valor de new_position, siempre va a ser mayor al valor de max_position, hay que buscar otra forma de identificar cuando una ficha ya dió la vuelta completa para iniciar su camino al cielo.
	return new_position

func get_max_position_for_color(color):
	if color == "yellow":
		return 68
	elif color == "blue":
		return 17
	elif color == "red":
		return 34
	elif color == "green":
		return 51
	return 68

func get_current_player_color():
	if current_player == 0:
		return "yellow"
	elif current_player == 1:
		return "blue"
	elif current_player == 2:
		return "red"
	else:
		return "green"

func update_turn_label():
	var player_color = get_current_player_color()
	turn_label.text = "Turno de: " + player_color.capitalize()

func is_safe_square(position):
	var safe_squares = [5, 12, 17, 22, 29, 34, 39, 46, 51, 56, 63, 68]
	return position in safe_squares

func get_token_at_position(position):
	for token in tokens:
		print("Token: ", token, "Position", token.current_position, "position", position)
		if token.current_position == position:
			return token
	return null

func ask_to_eat_token(player_token, target_token, steps):
	pending_steps = steps
	pending_token = player_token
	pending_target_token = target_token
	confirmation_dialog.popup_centered()

func _on_ConfirmationDialog_confirmed():
	if pending_target_token != null:
		pending_target_token.send_to_jail()
		print("Token sent to jail: ", pending_target_token.color)  # Depuración
		pending_token.move_to_position(pending_target_token.current_position)
		print("Token moved to position: ", pending_target_token.current_position)  # Depuración
		remaining_steps = pending_steps - pending_steps
		allow_move_remaining_steps(pending_token.color, remaining_steps)
	clear_pending_actions()


func _on_ConfirmationDialog_canceled():
	pending_token.move_steps(pending_steps)
	_restart_game()
	clear_pending_actions()

func clear_pending_actions():
	pending_steps = 0
	pending_token = null
	pending_target_token = null

func allow_move_remaining_steps(color, remaining_steps):
	dice_value_label.text = "Pasos restantes: " + str(remaining_steps)
	# Aquí esperaremos a que el jugador seleccione otra ficha para mover con los pasos restantes
	# Es posible que desees implementar algún mecanismo de tiempo de espera o límite de selección

# Método para mover la ficha a una posición específica
func move_to_position(token, position):
	token.current_position = position
	# Añade la lógica para actualizar visualmente la posición de la ficha si es necesario
func check_for_winner():
	var colors = ["yellow", "blue", "red", "green"]
	for color in colors:
		var all_in_heaven = true
		for token in tokens:
			if token.color == color and not token.in_heaven:
				all_in_heaven = false
				break
		if all_in_heaven:
			declare_winner(color)
			return

func declare_winner(color):
	var player_color = color.capitalize()
	confirmation_dialog.dialog_text = "¡El jugador " + player_color + " ha ganado!"
	confirmation_dialog.get_ok_button().text = "Reiniciar"
	confirmation_dialog.popup_centered()





func _restart_game():
	for token in tokens:
		token.reset_token()
	current_player = 0
	update_turn_label()
	dice_value_label.text = "Dado: "





