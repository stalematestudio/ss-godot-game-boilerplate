extends Node

onready var Music_Player = get_node("/root/main/Music_Player")
onready var FX_Player = get_node("/root/main/FX_Player")

onready var audio_bus_master = AudioServer.get_bus_index("Master")
onready var audio_bus_music = AudioServer.get_bus_index("Music")
onready var audio_bus_fx = AudioServer.get_bus_index("FX")

onready var navigate_audio = preload("res://assets/sounds/navigate.wav")
onready var deny_audio = preload("res://assets/sounds/deny.wav")
onready var accept_audio = preload("res://assets/sounds/accept.wav")
onready var cancel_audio = preload("res://assets/sounds/cancel.wav")

func ui_focus_entered_audio_effect():
	FX_Player.set_stream(navigate_audio)
	FX_Player.play()

func ui_pressed_audio_effect():
	FX_Player.set_stream(accept_audio)
	FX_Player.play()
