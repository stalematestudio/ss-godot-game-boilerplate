extends VBoxContainer

var action
var action_data
onready var action_label = $Action_Label
onready var action_data_label = $Action_Data_Label
onready var dead_zone_slider = $Deadzone_HBC/Deadzone_Slider
onready var dead_zone_display = $Deadzone_HBC/Deadzone_Display

func element_setup():
	self.name = action
	action_label.set_text(action)
	dead_zone_slider.set_value(action_data['deadzone'])
	dead_zone_slider.connect("value_changed", self, "deadzone_adjust")
	dead_zone_display.set_text(String(action_data['deadzone']))
	action_data_label.set_text(String(action_data['events']))

func deadzone_adjust(new_val):
	dead_zone_display.set_text(String(new_val))
