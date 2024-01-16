extends Control

@onready var event_timer = $event_timer
@onready var screen_display = $screen_display
@onready var event_counter = 0

@export (Array, Resource) var screens

func _ready():
	event_timer.connect("timeout", Callable(self, "_on_event_timer_timeout"))
	next_slide()

func _input(event): 
	if ( event is InputEventKey and event.is_pressed() ) or ( event is InputEventJoypadButton and event.is_pressed() ) or ( event is InputEventMouseButton and event.is_pressed() ) :
		get_viewport().set_input_as_handled()
		event_timer.start()
		event_counter += 1
		next_slide()

func _on_event_timer_timeout():
	event_counter += 1
	next_slide()

func next_slide():
	if event_counter < screens.size():
		screen_display.texture = screens[event_counter]
	else:
		GameManager.game_state_change("TITLE")
