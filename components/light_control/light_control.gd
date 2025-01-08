class_name LightControl extends MarginContainer

var display_parent: Node3D
var lights: Array[Light3D] = []

@onready var power_switch: CheckButton = $light_control_elements/switch
@onready var power_slider: HScrollBar = $light_control_elements/power/power
@onready var red_slider: HScrollBar = $light_control_elements/red/red
@onready var green_slider: HScrollBar = $light_control_elements/green/green
@onready var blue_slider: HScrollBar = $light_control_elements/blue/blue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for element in display_parent.get_children():
		if element is Light3D:
			lights.append(element)

	power_switch.toggled.connect(_on_power_switch)
	power_slider.value_changed.connect(_on_slider)
	red_slider.value_changed.connect(_on_slider)
	green_slider.value_changed.connect(_on_slider)
	blue_slider.value_changed.connect(_on_slider)

	_on_power_switch(false)
	_on_slider(float())

func _on_power_switch(toggled_on: bool) -> void:
	if toggled_on:
		for element in lights:
			element.show()
	else:
		for element in lights:
			element.hide()

func _on_slider(_value: float) -> void:
	for element in lights:
		element.light_energy = 0.02 * power_slider.value
		element.light_indirect_energy = 0.003 * power_slider.value
		element.light_volumetric_fog_energy = 0.01 * power_slider.value
		element.light_color = Color8(
			int(red_slider.value),
			int(green_slider.value),
			int(blue_slider.value),
		)
