class_name CharactersParent extends Node3D

@onready var play_area: PlayArea = get_parent()
@onready var characters_manager: CharactersManager = Helpers.get_game_manager("characters_manager")

var _character_list: Array[Character]
var character_list: Array[Character]:
	get:
		_character_list.clear()
		for child in get_children(false):
			if child is Character:
				_character_list.append(child)
		return _character_list

var scan_map_interval: float = 1.0
var scan_map_time: float = scan_map_interval

func _ready() -> void:
	if is_inside_tree() and not is_in_group("characters_parents"):
		add_to_group("characters_parents", true)
	tree_exiting.connect(_on_tree_exiting)
	if characters_manager.characters_data.has(play_area.name):
		load_data(characters_manager.characters_data[play_area.name])

func _process(delta: float) -> void:
	scan_map_time -= delta
	if scan_map_time > 0.0:
		return
	scan_map_time = scan_map_interval

	for body in play_area.get_overlapping_bodies():
		if ( body is Character ) and ( not body in character_list ):
			adopt_character(body)

func adopt_character(character: Character) -> void:
	Helpers.reparent_w_renaming(character, self)

func save_data() -> Array:
	var characters_data_list: Array = []
	for character in character_list:
		characters_data_list.append(character.save_data())
	return characters_data_list

func load_data(characters: Array = Array()) -> void:
	for child in get_children():
		if child is Character:
			child.free()
	for character in characters:
		var character_instance = load(character.scene).instantiate()
		add_child(character_instance)
		character_instance.load_data(character)

func _on_tree_exiting() -> void:
	characters_manager.characters_data[play_area.name] = save_data()
