class_name CharactersManager extends Node

@onready var game: GameplayManager = get_parent()

var _character_parents: Array[CharactersParent]
var character_parents: Array[CharactersParent]:
	get:
		_character_parents.clear()
		for play_area in game.maps_manager.active_play_areas:
			var character_parent: CharactersParent = get_character_parent(play_area)
			if character_parent:
				_character_parents.append(character_parent)
		return _character_parents

var characters_data: Dictionary = Dictionary()

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_managers"):
		add_to_group("game_managers", true)

func save_data() -> Dictionary:
	for character_parent in character_parents:
		characters_data[character_parent.play_area.name] = character_parent.save_data()
	return {
		"characters": characters_data
	}

func load_data(characters: Dictionary = Dictionary()) -> void:
	characters_data = characters if characters else characters_data
	for character_parent in character_parents:
		if characters_data.has(character_parent.play_area.name):
			character_parent.load_data(characters_data[character_parent.play_area.name])

func get_character_parent(play_area: PlayArea) -> CharactersParent:
	var play_area_children: Array[Node] = play_area.get_children()
	for child in play_area_children:
		if child is CharactersParent:
			return child
	return null
