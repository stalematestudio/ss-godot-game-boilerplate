extends Control

var continue_button
var new_game_button
var settings_button
var quit_button
var profiles_exist = false

var settings_menu_instance
export (PackedScene) var settings_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Mouse Mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Set element references
	continue_button = $Start_Menu/VBC/Continue
	new_game_button = $Start_Menu/VBC/New_Game
	settings_button = $Start_Menu/VBC/Settings
	quit_button = $Start_Menu/VBC/Quit
	
	# Set Start Menu
	if profiles_exist:
		continue_button.grab_focus()
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Called every time a button in the start menu is pressed
func start_menu_button_pressed(button_name):
	match button_name:
		"new":
			get_tree().change_scene("scenes/Demo.tscn")
		"continue":
			# Open profile select menu
			pass
		"settings":
			if is_instance_valid(settings_menu_instance):
				settings_menu_instance.queue_free()
			else:
				settings_menu_instance = settings_menu.instance()
				settings_menu_instance.return_focus_target = settings_button
				add_child(settings_menu_instance)
		"quit":
			get_tree().quit()
