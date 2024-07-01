extends Node2D
@export var color: String
signal token_selected

var current_position = 0
var path = []
var in_jail = true

var start_positions = {
	"yellow": 4,
	"blue": 21,
	"red": 38,
	"green": 55
}

func _ready():
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
		emit_signal("token_selected", self)

func move_to_position(new_position):
	current_position = new_position
	global_position = path[current_position].global_position

func move_steps(steps): # A partir de esta función se puede implementar el camino al cielo
	var target_position = current_position + steps
	if target_position < path.size():
		move_to_position(target_position)

func release_from_jail():
	in_jail = false
	move_to_position(start_positions[color])

func is_in_jail():
	return in_jail
