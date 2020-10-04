extends WindowDialog

onready var close_button = get_close_button()
onready var games_list = $VBoxContainer/HSplitContainer/GAMES_LIST/GAMES
onready var saves_list = $VBoxContainer/HSplitContainer/GAMES_LIST/SAVES

func _ready():
	connect("about_to_show", self, "list_games")
	
	close_button.set_focus_neighbour(MARGIN_BOTTOM, games_list.get_path())

	games_list.connect("item_activated", self, "_on_game_activated")
	games_list.connect("item_selected", self, "_on_game_selected")

	saves_list.connect("item_activated", self, "_on_save_activated")
	saves_list.connect("item_selected", self, "_on_save_selected")

func list_games():
	games_list.clear()
	saves_list.clear()
	ProfileManager.get_game_list()
	for game in ProfileManager.game_list:
		games_list.add_item(game)
	if games_list.get_item_count() > 0 :
		games_list.select(ProfileManager.game_current)
		_on_game_selected(ProfileManager.game_current)
		games_list.grab_focus()
	else:
		#selected_profile_name.set_text( ProfileManager.get_profile_name( ProfileManager.profile_current ) )
		#profile_create_button.grab_focus()
		#profile_select_button.set_disabled(true)
		#profile_delete_button.set_disabled(true)
		pass

func _on_game_activated(item_index):
	print("activated ", item_index)

func _on_game_selected(item_index):
	print("activated ", item_index)

func _on_save_activated(item_index):
	print("activated ", item_index)

func _on_save_selected(item_index):
	print("activated ", item_index)
	
