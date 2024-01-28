extends TabBar

@onready var gui_controller_label = $Settings_Scroll/Settings_VBC/Controller_HBC/Controller_Label
@onready var gui_controller_option = $Settings_Scroll/Settings_VBC/Controller_HBC/Controller_OptionButton
@onready var gui_controller_refresh_button = $Settings_Scroll/Settings_VBC/Controller_HBC/Controller_Refresh_Button

@onready var gui_vibration = $Settings_Scroll/Settings_VBC/Vibration_CheckButton

@onready var gui_weak_magnitude_label = $Settings_Scroll/Settings_VBC/WM_HBC/WM_Label
@onready var gui_weak_magnitude_slider = $Settings_Scroll/Settings_VBC/WM_HBC/WM_Slider
@onready var gui_weak_magnitude_display = $Settings_Scroll/Settings_VBC/WM_HBC/WM_Value

@onready var gui_strong_magnitude_label = $Settings_Scroll/Settings_VBC/SM_HBC/SM_Label
@onready var gui_strong_magnitude_slider = $Settings_Scroll/Settings_VBC/SM_HBC/SM_Slider
@onready var gui_strong_magnitude_display = $Settings_Scroll/Settings_VBC/SM_HBC/SM_Value

@onready var gui_weak_magnitude_test = $Settings_Scroll/Settings_VBC/TM_HBC/WM_Button
@onready var gui_strong_magnitude_test = $Settings_Scroll/Settings_VBC/TM_HBC/SM_Button
@onready var gui_magnitude_test = $Settings_Scroll/Settings_VBC/TM_HBC/CM_Button

@onready var gui_controller_left_y_invert = $Settings_Scroll/Settings_VBC/LY_CheckButton
@onready var gui_controller_left_y_sensitivity_slider = $Settings_Scroll/Settings_VBC/LY_HBC/LY_Slider
@onready var gui_controller_left_y_sensitivity_display = $Settings_Scroll/Settings_VBC/LY_HBC/LY_Value

@onready var gui_controller_left_x_invert = $Settings_Scroll/Settings_VBC/LX_CheckButton
@onready var gui_controller_left_x_sensitivity_slider = $Settings_Scroll/Settings_VBC/LX_HBC/LX_Slider
@onready var gui_controller_left_x_sensitivity_display = $Settings_Scroll/Settings_VBC/LX_HBC/LX_Value

@onready var gui_controller_right_y_invert = $Settings_Scroll/Settings_VBC/RY_CheckButton
@onready var gui_controller_right_y_sensitivity_slider = $Settings_Scroll/Settings_VBC/RY_HBC/RY_Slider
@onready var gui_controller_right_y_sensitivity_display = $Settings_Scroll/Settings_VBC/RY_HBC/RY_Value

@onready var gui_controller_right_x_invert = $Settings_Scroll/Settings_VBC/RX_CheckButton
@onready var gui_controller_right_x_sensitivity_slider = $Settings_Scroll/Settings_VBC/RX_HBC/RX_Slider
@onready var gui_controller_right_x_sensitivity_display = $Settings_Scroll/Settings_VBC/RX_HBC/RX_Value

@onready var gui_keybind = get_node("../keybind")

func _ready():
	controllers_list()

	gui_controller_option.connect("item_selected", Callable(self, "controller_select"))
	gui_controller_refresh_button.connect("pressed", Callable(self, "controllers_list"))

	Input.connect("joy_connection_changed", Callable(self, "controllers_list_changed"))

	gui_vibration.connect("pressed", Callable(self, "vibration_adjust"))

	gui_weak_magnitude_slider.connect("value_changed", Callable(self, "weak_magnitude_adjust"))
	gui_strong_magnitude_slider.connect("value_changed", Callable(self, "strong_magnitude_adjust"))
	
	gui_weak_magnitude_test.connect("pressed", Callable(self, "weak_magnitude_test"))
	gui_strong_magnitude_test.connect("pressed", Callable(self, "strong_magnitude_test"))
	gui_magnitude_test.connect("pressed", Callable(self, "vibration_magnitude_test"))

	gui_controller_left_y_invert.connect("pressed", Callable(self, "left_y_invert_adjust"))
	gui_controller_left_y_sensitivity_slider.connect("value_changed", Callable(self, "left_y_sensitivity_adjust"))
	
	gui_controller_left_x_invert.connect("pressed", Callable(self, "left_x_invert_adjust"))
	gui_controller_left_x_sensitivity_slider.connect("value_changed", Callable(self, "left_x_sensitivity_adjust"))
	
	gui_controller_right_y_invert.connect("pressed", Callable(self, "right_y_invert_adjust"))
	gui_controller_right_y_sensitivity_slider.connect("value_changed", Callable(self, "right_y_sensitivity_adjust"))
	
	gui_controller_right_x_invert.connect("pressed", Callable(self, "right_x_invert_adjust"))
	gui_controller_right_x_sensitivity_slider.connect("value_changed", Callable(self, "right_x_sensitivity_adjust"))

func set_form_values():
	gui_vibration.set_pressed(ConfigManager.config_data.controller.vibration)
	gui_weak_magnitude_slider.set_value(ConfigManager.config_data.controller.weak_magnitude)
	gui_strong_magnitude_slider.set_value(ConfigManager.config_data.controller.strong_magnitude)

	gui_controller_left_y_invert.set_pressed(ConfigManager.config_data.controller.left_y_inverted)
	gui_controller_left_y_sensitivity_slider.set_value(ConfigManager.config_data.controller.left_y_sensitivity)
	
	gui_controller_left_x_invert.set_pressed(ConfigManager.config_data.controller.left_x_inverted)
	gui_controller_left_x_sensitivity_slider.set_value(ConfigManager.config_data.controller.left_x_sensitivity)
	
	gui_controller_right_y_invert.set_pressed(ConfigManager.config_data.controller.right_y_inverted)
	gui_controller_right_y_sensitivity_slider.set_value(ConfigManager.config_data.controller.right_y_sensitivity)
	
	gui_controller_right_x_invert.set_pressed(ConfigManager.config_data.controller.right_x_inverted)
	gui_controller_right_x_sensitivity_slider.set_value(ConfigManager.config_data.controller.right_x_sensitivity)

	set_elements_disabled()

func set_elements_disabled():
	if InputManager.joypad_present:
		gui_controller_label.set_self_modulate(Color("#ffffffff"))
		gui_controller_option.set_disabled(false)
		gui_controller_refresh_button.set_disabled(false)
		gui_vibration.set_disabled(false)
	else:
		gui_controller_label.set_self_modulate(Color("#ffffff40"))
		gui_controller_option.set_disabled(true)
		gui_controller_refresh_button.set_disabled(true)
		gui_vibration.set_disabled(true)

	if gui_vibration.is_pressed() and InputManager.joypad_present:
		gui_weak_magnitude_label.set_self_modulate(Color("#ffffffff"))
		gui_weak_magnitude_slider.set_editable(true)
		gui_weak_magnitude_display.set_self_modulate(Color("#ffffffff"))
				
		gui_strong_magnitude_label.set_self_modulate(Color("#ffffffff"))
		gui_strong_magnitude_slider.set_editable(true)
		gui_strong_magnitude_display.set_self_modulate(Color("#ffffffff"))
		
		gui_weak_magnitude_test.set_disabled(false)
		gui_strong_magnitude_test.set_disabled(false)
		gui_magnitude_test.set_disabled(false)
	else:
		gui_weak_magnitude_label.set_self_modulate(Color("#ffffff40"))
		gui_weak_magnitude_slider.set_editable(false)
		gui_weak_magnitude_display.set_self_modulate(Color("#ffffff40"))
		
		gui_strong_magnitude_label.set_self_modulate(Color("#ffffff40"))
		gui_strong_magnitude_slider.set_editable(false)
		gui_strong_magnitude_display.set_self_modulate(Color("#ffffff40"))

		gui_weak_magnitude_test.set_disabled(true)
		gui_strong_magnitude_test.set_disabled(true)
		gui_magnitude_test.set_disabled(true)

# Controller
func controller_select(new_val):
	InputManager.joypad_device_id = new_val
	gui_keybind.set_form_values()

func controllers_list():
	gui_controller_option.clear()
	if InputManager.joypad_present:
		for j_pad in Input.get_connected_joypads():
			gui_controller_option.add_item(String.num(j_pad) + " : " + Input.get_joy_name( j_pad ), j_pad )
		gui_controller_option.select(InputManager.joypad_device_id)

func controllers_list_changed(device, connected):
	if connected:
		controllers_list()
	else:
		gui_controller_option.remove_item(device)
		if InputManager.joypad_present:
			gui_controller_option.select(InputManager.joypad_device_id)
	gui_keybind.set_form_values()
	set_elements_disabled()

# Vibration
func vibration_adjust():
	ConfigManager.config_data.controller.vibration = gui_vibration.is_pressed()
	set_elements_disabled()

func weak_magnitude_adjust(new_val):
	ConfigManager.config_data.controller.weak_magnitude = new_val
	gui_weak_magnitude_display.set_text(String.num(ConfigManager.config_data.controller.weak_magnitude))

func strong_magnitude_adjust(new_val):
	ConfigManager.config_data.controller.strong_magnitude = new_val
	gui_strong_magnitude_display.set_text(String.num(ConfigManager.config_data.controller.strong_magnitude))

func weak_magnitude_test():
	Input.start_joy_vibration(InputManager.joypad_device_id, ConfigManager.config_data.controller.weak_magnitude, 0, 1)
	
func strong_magnitude_test():
	Input.start_joy_vibration(InputManager.joypad_device_id, 0, ConfigManager.config_data.controller.strong_magnitude, 1)

func vibration_magnitude_test():
	Input.start_joy_vibration(InputManager.joypad_device_id, ConfigManager.config_data.controller.weak_magnitude, ConfigManager.config_data.controller.strong_magnitude, 1)

# Left Y
func left_y_invert_adjust():
	ConfigManager.config_data.controller.left_y_inverted = gui_controller_left_y_invert.is_pressed()

func left_y_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.left_y_sensitivity = new_val
	gui_controller_left_y_sensitivity_display.text = String.num(ConfigManager.config_data.controller.left_y_sensitivity)

# Left X
func left_x_invert_adjust():
	ConfigManager.config_data.controller.left_x_inverted = gui_controller_left_x_invert.is_pressed()

func left_x_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.left_x_sensitivity = new_val
	gui_controller_left_x_sensitivity_display.text = String.num(ConfigManager.config_data.controller.left_x_sensitivity)

# Right Y
func right_y_invert_adjust():
	ConfigManager.config_data.controller.right_y_inverted = gui_controller_right_y_invert.is_pressed()

func right_y_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.right_y_sensitivity = new_val
	gui_controller_right_y_sensitivity_display.text = String.num(ConfigManager.config_data.controller.right_y_sensitivity)

# Right X
func right_x_invert_adjust():
	ConfigManager.config_data.controller.right_x_inverted = gui_controller_right_x_invert.is_pressed()

func right_x_sensitivity_adjust(new_val):
	ConfigManager.config_data.controller.right_x_sensitivity = new_val
	gui_controller_right_x_sensitivity_display.text = String.num(ConfigManager.config_data.controller.right_x_sensitivity)
