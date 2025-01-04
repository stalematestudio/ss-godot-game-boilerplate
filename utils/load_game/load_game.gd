class_name LoadGameWindow extends Window

@onready var saves_list: ItemList = $VBoxContainer/games/scroll_container/SAVES_LIST

@onready var game_thumbnail: TextureRect = $VBoxContainer/games/GAME_DATA/thumbnail
@onready var game_difficulty: Label = $VBoxContainer/games/GAME_DATA/difficulty
@onready var game_level: Label = $VBoxContainer/games/GAME_DATA/level
@onready var game_time: Label = $VBoxContainer/games/GAME_DATA/time

@onready var load_button: Button = $VBoxContainer/games/GAME_DATA/LOAD
@onready var delete_button: Button = $VBoxContainer/games/GAME_DATA/DELETE
@onready var cancel_button: Button = $VBoxContainer/games/GAME_DATA/CANCEL

func _ready() -> void:
	ProfileManager.save_file_deleted.connect(list_saves)
	saves_list.item_selected.connect(_on_save_selected)
	saves_list.item_activated.connect(_on_save_activated)
	load_button.pressed.connect(_on_game_load_button_pressed)
	delete_button.pressed.connect(_on_game_delete_button_pressed)
	cancel_button.pressed.connect(close_requested.emit)
	list_saves()
	load_button.grab_focus()
	child_controls_changed()

func list_saves(_index: int = 0) -> void:
	saves_list.clear()
	var save_files: PackedStringArray = DirAccess.open(ProfileManager.save_dir_path).get_files()
	if not save_files:
		load_button.disabled = true
		delete_button.disabled = true
		cancel_button.grab_focus()
		return
	save_files.sort()
	save_files.reverse()
	for save_file in save_files:
		saves_list.add_item(save_file)
	load_button.disabled = false
	delete_button.disabled = false
	saves_list.select(0)
	_on_save_selected(saves_list.get_selected_items()[0])
	child_controls_changed()

func _on_save_selected(index: int) -> void:
	var save_file_path = ProfileManager.save_dir_path + saves_list.get_item_text(index)
	var save_file = FileAccess.open(save_file_path ,FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse( save_file.get_line() )
	var game_data = test_json_conv.get_data()
	save_file.close()
	# THUMB
	var thumb_image: Image
	if game_data.game.has("thumbnail"):
		thumb_image = Image.new()
		thumb_image.load_png_from_buffer( Marshalls.base64_to_raw( game_data.game.thumbnail ) )
		game_thumbnail.set_texture( ImageTexture.create_from_image( thumb_image ) )
	else:
		thumb_image = Image.create(1,1,false,Image.FORMAT_RGB8)
		thumb_image.fill_rect(Rect2i(0,0,1,1), Color.DARK_GRAY)
		game_thumbnail.set_texture( ImageTexture.create_from_image( thumb_image ) )
	game_difficulty.set_text( game_data.game.difficulty )
	game_level.set_text( " | ".join(game_data.game.levels_loaded) if game_data.game.has("levels_loaded") else "" )
	game_time.set_text( String.num( game_data.game.time ) if game_data.game.has("time") else "" )

func _on_save_activated(item_index: int) -> void:
	ProfileManager.game_data_path = ProfileManager.save_dir_path + saves_list.get_item_text(item_index)
	GameManager.game_state_change("IN_GAME")

func _on_game_load_button_pressed() -> void:
	_on_save_activated( saves_list.get_selected_items()[0] )

func _on_game_delete_button_pressed() -> void:
	var save_file_name: String = saves_list.get_item_text(saves_list.get_selected_items()[0])
	Utils.confirm_action(
		ProfileManager.del_save_file.bind(save_file_name),
		"DELETE: " + save_file_name,
		"Delete",
		)
