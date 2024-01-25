class_name  LevelManager

extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvent.reached_finish_line.connect(game_end)



func level_start():
	print("Countdown to one and start")

func game_end():
	print("Player reached the finish point")
