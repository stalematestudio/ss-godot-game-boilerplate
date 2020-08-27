extends VBoxContainer

var action
onready var action_label = $Action_Label
onready var dead_zone_slider = $Deadzone_HBC/Deadzone_Slider
onready var dead_zone_display = $Deadzone_HBC/Deadzone_Display

func element_setup():
	self.name = action
	action_label.set_text(action)
	dead_zone_slider.set_value(0)
	dead_zone_display.set_text(String())
