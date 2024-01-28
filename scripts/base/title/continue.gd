extends Window

# @onready var close_button = get_close_button()

@onready var games_list = $VBoxContainer/games/GAMES
@onready var saves_list = $VBoxContainer/games/SAVES

@onready var game_thumbnail = $VBoxContainer/games/GAME_DATA/thumbnail
@onready var game_difficulty = $VBoxContainer/games/GAME_DATA/difficulty
@onready var game_level = $VBoxContainer/games/GAME_DATA/level
@onready var game_time = $VBoxContainer/games/GAME_DATA/time

@onready var game_load_button = $VBoxContainer/games/GAME_DATA/LOAD
@onready var game_delete_game_button = $VBoxContainer/games/GAME_DATA/DELETE_GAME
@onready var game_delete_save_button = $VBoxContainer/games/GAME_DATA/DELETE_SAVE

@onready var game_delete_game_dialog = $GameDeleteDialog
@onready var game_delete_game_dialog_ok_button = game_delete_game_dialog.get_ok_button()
@onready var game_delete_game_dialog_cancel_button = game_delete_game_dialog.get_cancel_button()
@onready var game_delete_game_dialog_close_button = game_delete_game_dialog.get_close_button()

@onready var game_delete_save_dialog = $SaveDeleteDialog
@onready var game_delete_save_dialog_ok_button = game_delete_save_dialog.get_ok_button()
@onready var game_delete_save_dialog_cancel_button = game_delete_save_dialog.get_cancel_button()
@onready var game_delete_save_dialog_close_button = game_delete_save_dialog.get_close_button()

@onready var game_cancel_button = $VBoxContainer/CANCEL

# TODO: remove this temporary MARGIN_BOTTOM
const MARGIN_BOTTOM: int = 3

func _ready():
	connect("about_to_popup", Callable(self, "list_games"))
	
	# close_button.set_focus_neighbor(MARGIN_BOTTOM, games_list.get_path())
	
	game_delete_game_dialog_close_button.set_focus_neighbor(MARGIN_BOTTOM, game_delete_game_dialog_cancel_button.get_path())
	game_delete_save_dialog_close_button.set_focus_neighbor(MARGIN_BOTTOM, game_delete_save_dialog_cancel_button.get_path())
	
	games_list.connect("item_selected", Callable(self, "_on_game_activated_selected"))
	games_list.connect("item_activated", Callable(self, "_on_game_activated_selected"))

	saves_list.connect("item_selected", Callable(self, "_on_save_selected"))
	saves_list.connect("item_activated", Callable(self, "_on_save_activated"))

	game_load_button.connect("pressed", Callable(self, "_on_game_load_button_pressed"))
	
	game_delete_save_button.connect("pressed", Callable(self, "_on_game_delete_button_pressed").bind("save"))
	
	game_delete_game_button.connect("pressed", Callable(self, "_on_game_delete_button_pressed").bind("game"))
	
	game_delete_game_dialog.connect("about_to_popup", Callable(self, "_on_game_delete_dialog_about_to_show"))
	
	
	game_cancel_button.connect("pressed", Callable(self, "_on_game_cancel_button_pressed"))
	
	game_load_button.grab_focus()

func _on_game_load_button_pressed():
	_on_save_activated( saves_list.get_selected_items()[0] )

func _on_game_delete_button_pressed(what):
	match what:
		"save":
			pass
		"game":
			game_delete_game_dialog.set_text("Deleting game " + games_list.get_item_text( games_list.get_selected_items()[0] ) + " will permanetly remove saved games from your system. Are you sure???")
			game_delete_game_dialog.set_as_minsize()
			game_delete_game_dialog.popup_centered()
	list_games()

func _on_game_delete_dialog_about_to_show():
	game_delete_game_dialog_cancel_button.grab_focus()

func _on_game_delete_dialog_confirmed():
	ProfileManager.del_game( int( games_list.get_item_text( games_list.get_selected_items()[0] ) ) )

func _on_game_cancel_button_pressed():
	hide()

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
	var save_path = ProfileManager.get_game_save_path(game_index) + ProfileManager.game_save_list[item_index]
	var save_file = FileAccess.open(save_path ,FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse( save_file.get_line() )
	var game_data = test_json_conv.get_data()
	save_file.close()
	#game_thumbnail
	var thumb_image = Image.new()
	var thumb_image_texture = ImageTexture.new()
	if game_data.has("thumbnail"):
		thumb_image.load_png_from_buffer( Marshalls.base64_to_raw( game_data.thumbnail ) )
		thumb_image_texture.create_from_image( thumb_image )
		game_thumbnail.set_texture( thumb_image_texture )
	else:
		thumb_image_texture.create_from_image( thumb_image )
		game_thumbnail.set_texture( thumb_image_texture )
	game_difficulty.set_text( game_data.game_difficulty )
	game_level.set_text( game_data.game_level if game_data.has("game_level") else "" )
	game_time.set_text( String( game_data.game_time ) if game_data.has("game_time") else "" )

func _on_save_activated(item_index):
	ProfileManager.game_current = int( games_list.get_item_text( games_list.get_selected_items()[0] ) )
	ProfileManager.game_data_path = ProfileManager.get_game_save_path( ProfileManager.game_current ) + ProfileManager.game_save_list[item_index]
	ProfileManager.save_profile()
	GameManager.game_state_change("IN_GAME")
