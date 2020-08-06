extends Node

onready var Music_Player = AudioStreamPlayer
onready var FX_Player = AudioStreamPlayer

onready var audio_bus_music = AudioServer.get_bus_index("Music")
onready var audio_bus_fx = AudioServer.get_bus_index("FX")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
