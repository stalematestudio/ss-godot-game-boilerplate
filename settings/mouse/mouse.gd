extends TabBar

@onready var gui_mouse_horizontal_invert = $Settings_Scroll/Settings_VBC/Horizontal_CheckButton
@onready var gui_mouse_horizontal_sensitivity_slider = $Settings_Scroll/Settings_VBC/Horizontal_HBC/Horizontal_Slider
@onready var gui_mouse_horizontal_sensitivity_display = $Settings_Scroll/Settings_VBC/Horizontal_HBC/Horizontal_Value

@onready var gui_mouse_vertical_invert = $Settings_Scroll/Settings_VBC/Vertical_CheckButton
@onready var gui_mouse_vertical_sensitivity_slider = $Settings_Scroll/Settings_VBC/Vertical_HBC/Vertical_Slider
@onready var gui_mouse_vertical_sensitivity_display = $Settings_Scroll/Settings_VBC/Vertical_HBC/Vertical_Value

@onready var gui_mouse_scroll_invert = $Settings_Scroll/Settings_VBC/Scroll_CheckButton
@onready var gui_mouse_scroll_sensitivity_slider = $Settings_Scroll/Settings_VBC/Scroll_HBC/Scroll_Slider
@onready var gui_mouse_scroll_sensitivity_display = $Settings_Scroll/Settings_VBC/Scroll_HBC/Scroll_Value

func _ready():
	gui_mouse_horizontal_invert.connect("pressed", Callable(self, "mouse_horizontal_invert_adjust"))
	gui_mouse_horizontal_sensitivity_slider.connect("value_changed", Callable(self, "mouse_horizontal_sensitivity_adjust"))

	gui_mouse_vertical_invert.connect("pressed", Callable(self, "mouse_vertical_invert_adjust"))
	gui_mouse_vertical_sensitivity_slider.connect("value_changed", Callable(self, "mouse_vertical_sensitivity_adjust"))

	gui_mouse_scroll_invert.connect("pressed", Callable(self, "mouse_scroll_invert_adjust"))
	gui_mouse_scroll_sensitivity_slider.connect("value_changed", Callable(self, "mouse_scroll_sensitivity_adjust"))

func set_form_values():
	gui_mouse_horizontal_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_x)
	gui_mouse_horizontal_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_x)
	
	gui_mouse_vertical_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_y)
	gui_mouse_vertical_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_y)
	
	gui_mouse_scroll_invert.set_pressed(ConfigManager.config_data.mouse.mouse_inverted_scroll)
	gui_mouse_scroll_sensitivity_slider.set_value(ConfigManager.config_data.mouse.mouse_sensitivity_scroll)

func mouse_horizontal_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_x = gui_mouse_horizontal_invert.is_pressed()

func mouse_horizontal_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_x = new_val
	gui_mouse_horizontal_sensitivity_display.text = String.num(ConfigManager.config_data.mouse.mouse_sensitivity_x)

func mouse_vertical_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_y = gui_mouse_vertical_invert.is_pressed()

func mouse_vertical_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_y = new_val
	gui_mouse_vertical_sensitivity_display.text = String.num(ConfigManager.config_data.mouse.mouse_sensitivity_y)

func mouse_scroll_invert_adjust():
	ConfigManager.config_data.mouse.mouse_inverted_scroll = gui_mouse_scroll_invert.is_pressed()

func mouse_scroll_sensitivity_adjust(new_val):
	ConfigManager.config_data.mouse.mouse_sensitivity_scroll = new_val
	gui_mouse_scroll_sensitivity_display.text = String.num(ConfigManager.config_data.mouse.mouse_sensitivity_scroll)
