extends Node2D

@export var dice_sides: Array[Texture2D] = [
	preload("res://Assets/d1.png"),
	preload("res://Assets/d2.png"),
	preload("res://Assets/d3.png"),
	preload("res://Assets/d4.png"),
	preload("res://Assets/d5.png"),
	preload("res://Assets/d6.png")
]
var dice_value_1: int = 1
var dice_value_2: int = 1

func roll():
	dice_value_1 = randi() % 6 + 1
	dice_value_2 = randi() % 6 + 1
	update_dice_faces()
	return dice_value_1 + dice_value_2

func update_dice_faces():
	$Dice1.texture = dice_sides[dice_value_1 - 1]
	$Dice2.texture = dice_sides[dice_value_2 - 1]

func get_dice_values():
	return [dice_value_1, dice_value_2]
