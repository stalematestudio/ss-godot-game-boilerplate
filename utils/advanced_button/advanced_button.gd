class_name AdvancedButton extends Button

@export var double_press_interval: int = 500
@onready var last_pressed: int = Time.get_ticks_msec() 

signal double_pressed

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	var diff_pressed: int = Time.get_ticks_msec() - last_pressed
	last_pressed = Time.get_ticks_msec()
	if diff_pressed <= double_press_interval:
		double_pressed.emit()
