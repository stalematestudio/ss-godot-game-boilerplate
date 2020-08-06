extends Control

# Set element references
onready var game_title = $Start_Menu/VBC/Game_Title
onready var continue_button = $Start_Menu/VBC/Continue
onready var new_game_button = $Start_Menu/VBC/New_Game
onready var settings_button = $Start_Menu/VBC/Settings
onready var quit_button = $Start_Menu/VBC/Quit

var profiles_exist = false

var settings_menu_instance
export (PackedScene) var settings_menu
export (AudioStreamSample) var focus_entered_audio
export (AudioStreamSample) var accept_audio

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set Mouse Mode
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Set Start Menu
	game_title.text = ProjectSettings.get_setting("application/config/name")
	if profiles_exist:
		continue_button.grab_focus()
		continue_button.connect("pressed", self, "start_menu_button_pressed", ["continue"])
		continue_button.connect("focus_entered", self, "focus_entered_effect")
	else:
		continue_button.set_disabled(true)
		new_game_button.grab_focus()
	
	new_game_button.connect("pressed", self, "start_menu_button_pressed", ["new"])
	new_game_button.connect("focus_entered", self, "focus_entered_effect")
	
	settings_button.connect("pressed", self, "start_menu_button_pressed", ["settings"])
	settings_button.connect("focus_entered", self, "focus_entered_effect")
	
	quit_button.connect("pressed", self, "start_menu_button_pressed", ["quit"])
	quit_button.connect("focus_entered", self, "focus_entered_effect")
	
	# Loop through buttons
	for button in get_tree().get_nodes_in_group('main_menu_button_group'):
		print(button.name)
		button.connect("focus_entered", self, "focus_entered_effect")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func focus_entered_effect():
	#$FX_Player.set_stream(focus_entered_audio)
	#$FX_Player.play()
	pass

# Called every time a button in the start menu is pressed
func start_menu_button_pressed(button_name):
	#$FX_Player.set_stream(accept_audio)
	#$FX_Player.play()
	match button_name:
		"new":
			get_tree().change_scene("scenes/demo/Demo.tscn")
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
