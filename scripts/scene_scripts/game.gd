extends Node

onready var game_time = 0

func  _process(delta):
	game_time += delta
