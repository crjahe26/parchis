extends Node2D

@export var color: String
signal token_selected

var current_position = 0
var path = []
var in_jail = true
var in_heaven = false  # Estado para indicar si la ficha está en el cielo
var has_won = false  # Estado para indicar si la ficha ha ganado

@onready var victory_dialog = $"../VictoryDialog"

var start_positions = {
	"yellow": 5,
	"blue": 22,
	"red": 39,
	"green": 56
}

var jail_nodes = {
	"yellow": "/root/Node2D/Board/JailYellow",
	"blue": "/root/Node2D/Board/JailBlue",
	"red": "/root/Node2D/Board/JailRed",
	"green": "/root/Node2D/Board/JailGreen"
}

var heaven_paths = {}

func _ready():
	heaven_paths["yellow"] = [
		get_node("/root/Node2D/Board/heaven_yellow_1"),
		get_node("/root/Node2D/Board/heaven_yellow_2"),
		get_node("/root/Node2D/Board/heaven_yellow_3"),
		get_node("/root/Node2D/Board/heaven_yellow_4"),
		get_node("/root/Node2D/Board/heaven_yellow_5"),
		get_node("/root/Node2D/Board/heaven_yellow_6"),
		get_node("/root/Node2D/Board/heaven_yellow_7"),
		get_node("/root/Node2D/Board/heaven_yellow_8")
	]
	heaven_paths["blue"] = [
		get_node("/root/Node2D/Board/heaven_blue_1"),
		get_node("/root/Node2D/Board/heaven_blue_2"),
		get_node("/root/Node2D/Board/heaven_blue_3"),
		get_node("/root/Node2D/Board/heaven_blue_4"),
		get_node("/root/Node2D/Board/heaven_blue_5"),
		get_node("/root/Node2D/Board/heaven_blue_6"),
		get_node("/root/Node2D/Board/heaven_blue_7"),
		get_node("/root/Node2D/Board/heaven_blue_8")
	]
	heaven_paths["red"] = [
		get_node("/root/Node2D/Board/heaven_red_1"),
		get_node("/root/Node2D/Board/heaven_red_2"),
		get_node("/root/Node2D/Board/heaven_red_3"),
		get_node("/root/Node2D/Board/heaven_red_4"),
		get_node("/root/Node2D/Board/heaven_red_5"),
		get_node("/root/Node2D/Board/heaven_red_6"),
		get_node("/root/Node2D/Board/heaven_red_7"),
		get_node("/root/Node2D/Board/heaven_red_8")
	]
	heaven_paths["green"] = [
		get_node("/root/Node2D/Board/heaven_green_1"),
		get_node("/root/Node2D/Board/heaven_green_2"),
		get_node("/root/Node2D/Board/heaven_green_3"),
		get_node("/root/Node2D/Board/heaven_green_4"),
		get_node("/root/Node2D/Board/heaven_green_5"),
		get_node("/root/Node2D/Board/heaven_green_6"),
		get_node("/root/Node2D/Board/heaven_green_7"),
		get_node("/root/Node2D/Board/heaven_green_8")
	]

	path = [
		$"/root/Node2D/Board/Square1",
		$"/root/Node2D/Board/Square2",
		$"/root/Node2D/Board/Square3",
		$"/root/Node2D/Board/Square4",
		$"/root/Node2D/Board/Square5",
		$"/root/Node2D/Board/Square6",
		$"/root/Node2D/Board/Square7",
		$"/root/Node2D/Board/Square8",
		$"/root/Node2D/Board/Square9",
		$"/root/Node2D/Board/Square10",
		$"/root/Node2D/Board/Square11",
		$"/root/Node2D/Board/Square12",
		$"/root/Node2D/Board/Square13",
		$"/root/Node2D/Board/Square14",
		$"/root/Node2D/Board/Square15",
		$"/root/Node2D/Board/Square16",
		$"/root/Node2D/Board/Square17",
		$"/root/Node2D/Board/Square18",
		$"/root/Node2D/Board/Square19",
		$"/root/Node2D/Board/Square20",
		$"/root/Node2D/Board/Square21",
		$"/root/Node2D/Board/Square22",
		$"/root/Node2D/Board/Square23",
		$"/root/Node2D/Board/Square24",
		$"/root/Node2D/Board/Square25",
		$"/root/Node2D/Board/Square26",
		$"/root/Node2D/Board/Square27",
		$"/root/Node2D/Board/Square28",
		$"/root/Node2D/Board/Square29",
		$"/root/Node2D/Board/Square30",
		$"/root/Node2D/Board/Square31",
		$"/root/Node2D/Board/Square32",
		$"/root/Node2D/Board/Square33",
		$"/root/Node2D/Board/Square34",
		$"/root/Node2D/Board/Square35",
		$"/root/Node2D/Board/Square36",
		$"/root/Node2D/Board/Square37",
		$"/root/Node2D/Board/Square38",
		$"/root/Node2D/Board/Square39",
		$"/root/Node2D/Board/Square40",
		$"/root/Node2D/Board/Square41",
		$"/root/Node2D/Board/Square42",
		$"/root/Node2D/Board/Square43",
		$"/root/Node2D/Board/Square44",
		$"/root/Node2D/Board/Square45",
		$"/root/Node2D/Board/Square46",
		$"/root/Node2D/Board/Square47",
		$"/root/Node2D/Board/Square48",
		$"/root/Node2D/Board/Square49",
		$"/root/Node2D/Board/Square50",
		$"/root/Node2D/Board/Square51",
		$"/root/Node2D/Board/Square52",
		$"/root/Node2D/Board/Square53",
		$"/root/Node2D/Board/Square54",
		$"/root/Node2D/Board/Square55",
		$"/root/Node2D/Board/Square56",
		$"/root/Node2D/Board/Square57",
		$"/root/Node2D/Board/Square58",
		$"/root/Node2D/Board/Square59",
		$"/root/Node2D/Board/Square60",
		$"/root/Node2D/Board/Square61",
		$"/root/Node2D/Board/Square62",
		$"/root/Node2D/Board/Square63",
		$"/root/Node2D/Board/Square64",
		$"/root/Node2D/Board/Square65",
		$"/root/Node2D/Board/Square66",
		$"/root/Node2D/Board/Square67",
		$"/root/Node2D/Board/Square68"
	]
	$Area2D.connect("input_event", Callable(self, "_on_Area2D_input_event"))
	current_position = start_positions[color]

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if has_won:
			if victory_dialog != null:
				victory_dialog.popup_centered()
			else:
				print("VictoryDialog no está asignado correctamente.")
		else:
			emit_signal("token_selected", self)

func move_to_position(new_position):
	current_position = new_position
	if in_heaven:
		global_position = heaven_paths[color][current_position - 1].global_position
	else:
		global_position = path[current_position - 1].global_position
	print("Ficha movida a la posición: ", current_position, " (global_position: ", global_position, ")")  # depuración

func move_steps(steps):
	if in_heaven:
		move_to_heaven(steps)
		return

	var initial_position = current_position
	var target_position = calculate_target_position(initial_position, steps)

	# Si el objetivo está dentro del tablero normal
	if target_position <= 68:
		for i in range(steps):
			current_position += 1
			if current_position > 68:
				current_position = 1
			global_position = path[current_position - 1].global_position
			await get_tree().create_timer(0.5).timeout
			print("Ficha movida a la posición: ", current_position)

			# Si alcanzamos la posición para subir al cielo
			if current_position == get_heaven_start_position(color):
				var remaining_steps = steps - (i + 1)
				in_heaven = true  # Marcamos la ficha como en el cielo
				current_position = 0  # Reiniciamos current_position para usarla en el cielo
				move_to_heaven(remaining_steps)
				return
	else:
		# Caso en que se mueve hacia el cielo directamente
		var normal_steps = get_normal_steps_to_heaven(initial_position)
		for i in range(min(steps, normal_steps)):
			current_position += 1
			if current_position > 68:
				current_position = 1
			global_position = path[current_position - 1].global_position
			await get_tree().create_timer(0.5).timeout
			print("Ficha movida a la posición: ", current_position)

		var remaining_steps = steps - normal_steps
		if remaining_steps > 0:
			in_heaven = true  # Marcamos la ficha como en el cielo
			current_position = 0  # Reiniciamos current_position para usarla en el cielo
			move_to_heaven(remaining_steps)

func calculate_target_position(initial_position, steps):
	var target_position = initial_position + steps

	if target_position > 68:
		target_position -= 68

	return target_position

func get_heaven_start_position(color):
	if color == "yellow":
		return 68
	elif color == "blue":
		return 17
	elif color == "red":
		return 34
	elif color == "green":
		return 51
	return 68

func get_normal_steps_to_heaven(initial_position):
	var heaven_start_position = get_heaven_start_position(color)
	if initial_position <= heaven_start_position:
		return heaven_start_position - initial_position
	else:
		return 68 - initial_position + heaven_start_position

func move_to_heaven(steps):
	var heaven_path = heaven_paths[color]
	for i in range(steps):
		current_position += 1
		if current_position > 8:
			current_position = 8
		global_position = heaven_path[current_position - 1].global_position
		await get_tree().create_timer(0.5).timeout
		print("Ficha movida al cielo a la posición: ", current_position)

		if current_position == 8:
			in_heaven = true
			if has_won:
				emit_signal("token_selected", self)
			return


func release_from_jail():
	in_jail = false
	in_heaven = false  # Asegurarse de que no esté en el cielo
	move_to_position(start_positions[color])

func is_in_jail():
	return in_jail

func send_to_jail():
	in_jail = true
	in_heaven = false  # Asegurarse de que no esté en el cielo
	has_won = false  # Resetear la condición de victoria
	var jail_node = get_node(jail_nodes[color])
	global_position = jail_node.global_position
	print("Ficha enviada a la cárcel: ", color, " en posición: ", global_position)  # Depuración

func check_collision():
	for token in get_tree().get_nodes_in_group("tokens"):
		if token != self and not token.is_in_jail() and token.current_position == self.current_position:
			print("Ficha ", color, " ha comido a ficha ", token.color)
			token.send_to_jail()
func reset_token():
	current_position = start_positions[color]
	in_jail = true
	in_heaven = false
	global_position = path[current_position - 1].global_position
