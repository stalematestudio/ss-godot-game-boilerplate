extends WindowDialog

onready var close_button = get_close_button()

onready var games_list = $VBoxContainer/games/GAMES
onready var saves_list = $VBoxContainer/games/SAVES

onready var game_load_button = $VBoxContainer/BUTTONS/LOAD
onready var game_cancel_button = $VBoxContainer/BUTTONS/CANCEL

func _ready():
	connect("about_to_show", self, "list_games")
	
	close_button.set_focus_neighbour(MARGIN_BOTTOM, games_list.get_path())

	games_list.connect("item_selected", self, "_on_game_activated_selected")
	games_list.connect("item_activated", self, "_on_game_activated_selected")

	saves_list.connect("item_selected", self, "_on_save_selected")
	saves_list.connect("item_activated", self, "_on_save_activated")

	game_load_button.connect("pressed", self, "_on_game_load_button_pressed")
	game_cancel_button.connect("pressed", self, "_on_game_cancel_button_pressed")

	game_load_button.grab_focus()

func _on_game_load_button_pressed():
	pass

func _on_game_cancel_button_pressed():
	pass

func list_games():
	games_list.clear()
	ProfileManager.get_game_list()
	for game in ProfileManager.game_list:
		games_list.add_item(game)
	if games_list.get_item_count() > 0 :
		games_list.select(ProfileManager.game_current)
		_on_game_activated_selected(ProfileManager.game_current)
		games_list.grab_focus()

func list_saves(game_index):
	saves_list.clear()
	ProfileManager.get_game_save_list(game_index)
	for save in ProfileManager.game_save_list:
		saves_list.add_item(save)
		#if ProfileManager.game_data_path.ends_with(save):
		#	saves_list.select( saves_list.get_item_count() -1 )
	saves_list.select(0)
	_on_save_selected(saves_list.get_selected_items()[0])

func _on_game_activated_selected(item_index):
	list_saves( int( games_list.get_item_text( item_index ) ) )

func _on_save_selected(item_index):
	var game_index = int( games_list.get_item_text( games_list.get_selected_items()[0] ) )
	ProfileManager.get_game_save_list( game_index )
	print( ProfileManager.game_save_list[item_index] )

func _on_save_activated(item_index):
	print("save activated ", item_index)
