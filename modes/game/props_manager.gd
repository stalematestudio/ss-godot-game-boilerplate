class_name PropsManager extends Node

@onready var game: GameplayManager = get_parent()

var _props_parents: Array[PropsParent]
var props_parents: Array[PropsParent]:
	get:
		_props_parents.clear()
		for play_area in game.maps_manager.active_play_areas:
			var prop_parent: PropsParent = get_prop_parent(play_area)
			if prop_parent:
				_props_parents.append(prop_parent)
		return _props_parents

var props_data: Dictionary = Dictionary()

var scan_map_interval: float = 1.0
var scan_map_time: float = scan_map_interval

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_managers"):
		add_to_group("game_managers", true)

func save_data() -> Dictionary:
	for props_parent in props_parents:
		props_data[props_parent.play_area.name] = props_parent.save_data()
	return {
		"props": props_data
	}

func load_data(props: Dictionary = Dictionary()) -> void:
	props_data = props if props else props_data
	for props_parent in props_parents:
		if props_data.has(props_parent.play_area.name):
			props_parent.load_data(props_data[props_parent.play_area.name])

func get_prop_parent(play_area: PlayArea) -> PropsParent:
	var play_area_children: Array[Node] = play_area.get_children()
	for child in play_area_children:
		if child is PropsParent:
			return child
	return null
