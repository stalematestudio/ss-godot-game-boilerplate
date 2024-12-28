class_name LoadGameWindow extends Window

@onready var games_list: ItemList = $VBoxContainer/games/GAMES
@onready var saves_list: ItemList = $VBoxContainer/games/SAVES

@onready var game_thumbnail: TextureRect = $VBoxContainer/games/GAME_DATA/thumbnail
@onready var game_difficulty: Label = $VBoxContainer/games/GAME_DATA/difficulty
@onready var game_level: Label = $VBoxContainer/games/GAME_DATA/level
@onready var game_time: Label = $VBoxContainer/games/GAME_DATA/time

@onready var game_load_button: Button = $VBoxContainer/games/GAME_DATA/LOAD
@onready var game_delete_game_button: Button = $VBoxContainer/games/GAME_DATA/DELETE_GAME
@onready var game_delete_save_button: Button = $VBoxContainer/games/GAME_DATA/DELETE_SAVE

@onready var game_cancel_button: Button = $VBoxContainer/CANCEL

func _ready() -> void:
	list_games()
	games_list.item_selected.connect(list_saves)
	games_list.item_activated.connect(list_saves)
	saves_list.item_selected.connect(_on_save_selected)
	saves_list.item_activated.connect(_on_save_activated)
	game_load_button.pressed.connect(_on_game_load_button_pressed)
	game_delete_save_button.pressed.connect(_on_game_delete_button_pressed.bind("save"))
	game_delete_game_button.pressed.connect(_on_game_delete_button_pressed.bind("game"))
	game_cancel_button.pressed.connect(close_requested.emit)
	ProfileManager.game_deleted.connect(list_games)
	ProfileManager.save_file_deleted.connect(list_saves)
	game_load_button.grab_focus()
	child_controls_changed()

func list_games(_index: int = 0) -> void:
	games_list.clear()
	ProfileManager.get_game_list()
	if ProfileManager.game_list:
		for game in ProfileManager.game_list:
			games_list.add_item(game)
		games_list.select(ProfileManager.game_current)
		list_saves()
		game_delete_game_button.disabled = false
		games_list.grab_focus()
	else:
		game_delete_game_button.disabled = true
		game_cancel_button.grab_focus()
	child_controls_changed()

func list_saves(index: int = 0) -> void:
	saves_list.clear()
	ProfileManager.set_game_current(int(games_list.get_item_text(index)))
	ProfileManager.get_game_save_list_current()
	if ProfileManager.game_save_list:
		for save in ProfileManager.game_save_list:
			saves_list.add_item(save)
		saves_list.select(0)
		_on_save_selected(saves_list.get_selected_items()[0])
		game_load_button.grab_focus()
		game_load_button.disabled = false
		game_delete_save_button.disabled = false
	else:
		game_load_button.disabled = true
		game_delete_save_button.disabled = true
	child_controls_changed()

func _on_save_selected(item_index: int) -> void:
	var game_index = int( games_list.get_item_text( games_list.get_selected_items()[0] ) )
	ProfileManager.get_game_save_list( game_index )
	var save_path = ProfileManager.get_game_save_path(game_index) + ProfileManager.game_save_list[item_index]
	var save_file = FileAccess.open(save_path ,FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse( save_file.get_line() )
	var game_data = test_json_conv.get_data()
	save_file.close()
	# THUMB
	var thumb_image: Image
	if game_data.has("thumbnail"):
		thumb_image = Image.new()
		thumb_image.load_png_from_buffer( Marshalls.base64_to_raw( game_data.thumbnail ) )
		game_thumbnail.set_texture( ImageTexture.create_from_image( thumb_image ) )
	else:
		thumb_image = Image.create(1,1,false,Image.FORMAT_RGB8)
		thumb_image.fill_rect(Rect2i(0,0,1,1), Color.DARK_GRAY)
		game_thumbnail.set_texture( ImageTexture.create_from_image( thumb_image ) )

	game_difficulty.set_text( game_data.game_difficulty )
	game_level.set_text( game_data.game_level if game_data.has("game_level") else "" )
	game_time.set_text( String.num( game_data.game_time ) if game_data.has("game_time") else "" )

func _on_save_activated(item_index: int) -> void:
	ProfileManager.game_current = int( games_list.get_item_text( games_list.get_selected_items()[0] ) )
	ProfileManager.game_data_path = ProfileManager.get_game_save_path( ProfileManager.game_current ) + ProfileManager.game_save_list[item_index]
	ProfileManager.save_profile()
	GameManager.game_state_change("IN_GAME")

func _on_game_load_button_pressed() -> void:
	_on_save_activated( saves_list.get_selected_items()[0] )

func _on_game_delete_button_pressed(what: String) -> void:
	if games_list:
		var game_index: int = int(games_list.get_item_text(games_list.get_selected_items()[0]))
		match what:
			"save":
				var save_file_name: String = saves_list.get_item_text(saves_list.get_selected_items()[0])
				Utils.confirm_action(
					ProfileManager.del_save_file.bind(game_index, save_file_name),
					"DELETE: " + String.num(game_index) + " / " + save_file_name,
					"Delete",
					)
			"game":
				Utils.confirm_action(
					ProfileManager.del_game.bind(game_index),
					"DELETE GAME: " + String.num(game_index),
					"Delete",
				)
