extends Node

onready var root = get_node("/root")

onready var Music_Player = get_node("/root/main/Music_Player")
onready var FX_Player = get_node("/root/main/FX_Player")

onready var audio_bus_master = AudioServer.get_bus_index("Master")
onready var audio_bus_music = AudioServer.get_bus_index("Music")
onready var audio_bus_fx = AudioServer.get_bus_index("FX")

onready var navigate_audio = preload("res://assets/audio/ui_effects/navigate.wav")
onready var deny_audio = preload("res://assets/audio/ui_effects/deny.wav")
onready var accept_audio = preload("res://assets/audio/ui_effects/accept.wav")
onready var cancel_audio = preload("res://assets/audio/ui_effects/cancel.wav")

func ui_navigate_audio_effect(target=null):
	print(target)
	FX_Player.set_stream(navigate_audio)
	FX_Player.play()

func ui_deny_audio_effect():
	FX_Player.set_stream(deny_audio)
	FX_Player.play()

func ui_accept_audio_effect():
	FX_Player.set_stream(accept_audio)
	FX_Player.play()

func ui_cancel_audio_effect():
	FX_Player.set_stream(cancel_audio)
	FX_Player.play()
