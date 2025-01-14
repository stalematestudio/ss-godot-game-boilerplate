class_name MapsManager extends Node

@onready var game: GameplayManager = get_parent()

"""
Map:
	demo_3A demo_3B demo_3C demo_3D
	demo_2A demo_2B demo_2C demo_2D
	demo_1A demo_1B demo_1C demo_1D
	demo_0A	demo_0B demo_0C demo_0D
"""

var game_map: Dictionary = {
	"demo_0A": {
		"scene": preload("res://level/empty_level/empty_level.tscn"),
		"name": "demo_0A",
		"position": Vector3(0,0,0),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_1A","demo_0B","demo_1B"]
		},
	"demo_1A": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_1A",
		"position": Vector3(80,0,0),
		"rotation_degrees": Vector3(0,90,0),
		"neightbours": ["demo_0A","demo_2A","demo_0B","demo_1B","demo_2B"]
		},
	"demo_2A": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_2A",
		"position": Vector3(160,0,0),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_1A","demo_3A","demo_1B","demo_2B","demo_3B"]
		},
	"demo_3A": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_3A",
		"position": Vector3(240,0,0),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_2A","demo_2B","demo_3B"]
		},
	"demo_0B": {
		"scene": preload("res://level/empty_level/empty_level.tscn"),
		"name": "demo_0B",
		"position": Vector3(0,0,80),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0A","demo_1A","demo_1B","demo_0C","demo_1C"]
		},
	"demo_1B": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_1B",
		"position": Vector3(80,0,80),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0A","demo_1A","demo_2A","demo_0B","demo_2B","demo_0C","demo_1C","demo_2C"]
		},
	"demo_2B": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_2B",
		"position": Vector3(160,0,80),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_1A","demo_2A","demo_3A","demo_1B","demo_3B","demo_1C","demo_2C","demo_3C"]
		},
	"demo_3B": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_3B",
		"position": Vector3(240,0,80),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_2A","demo_3A","demo_2B","demo_2C","demo_3C"]
		},
	"demo_0C": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_0C",
		"position": Vector3(0,0,160),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0B","demo_1B","demo_1C","demo_0D","demo_1D"]
		},
	"demo_1C": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_1C",
		"position": Vector3(80,0,160),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0B","demo_1B","demo_2B","demo_0C","demo_2C","demo_0D","demo_1D","demo_2D"]
		},
	"demo_2C": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_2C",
		"position": Vector3(160,0,160),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_1B","demo_2B","demo_3B","demo_1C","demo_3C","demo_1D","demo_2D","demo_3D"]
		},
	"demo_3C": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_3C",
		"position": Vector3(240,0,160),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_2B","demo_3B","demo_2C","demo_2D","demo_3D"]
		},
	"demo_0D": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_0D",
		"position": Vector3(0,0,240),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0C","demo_1C","demo_1D"]
		},
	"demo_1D": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_1D",
		"position": Vector3(80,0,240),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_0C","demo_1C","demo_2C","demo_0D","demo_2D"]
		},
	"demo_2D": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_2D",
		"position": Vector3(160,0,240),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_1C","demo_2C","demo_3C","demo_1D","demo_3D"]
		},
	"demo_3D": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_3D",
		"position": Vector3(240,0,240),
		"rotation_degrees": Vector3(),
		"neightbours": ["demo_2C","demo_3C","demo_2D"]
		},
}

var _level_active: String = "demo_0A"
var level_active: String:
	get:
		return _level_active
	set(new_level_active):
		_level_active = new_level_active
		instantiate_maps()

var levels_loaded: PackedStringArray:
	get:
		var _levels_loaded: PackedStringArray = PackedStringArray()
		_levels_loaded.append(level_active)
		_levels_loaded.append_array(game_map[level_active].neightbours)
		return _levels_loaded

var _active_play_areas: Array[PlayArea]
var active_play_areas: Array[PlayArea]:
	get:
		_active_play_areas.clear()
		for child in get_children():
			if child is PlayArea:
				_active_play_areas.append(child)
		return _active_play_areas

var _active_play_area_names: PackedStringArray = PackedStringArray()
var active_play_area_names: PackedStringArray:
	get:
		_active_play_area_names.clear()
		for child in get_children():
			if child is PlayArea:
				_active_play_area_names.append(child.name)
		return _active_play_area_names

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_managers"):
		add_to_group("game_managers", true)

func save_data() -> Dictionary:
	return {
		"maps": {
			"level_active": level_active,
			"levels_loaded": levels_loaded,
		}
	}

func load_data(maps: Dictionary = Dictionary()) -> void:
	instantiate_map(maps.level_active if maps else _level_active)

func instantiate_maps() -> void:
	active_play_area_names.clear()
	for loaded_level in get_children():
		active_play_area_names.append(loaded_level.name)
	Helpers.array_difference(levels_loaded, active_play_area_names)
	for level in levels_loaded:
		instantiate_map(level)
	for level in get_children():
		if not level.name in levels_loaded:
			level.queue_free()

func instantiate_map(map_name: String) -> void:	
	if map_name in active_play_area_names:
		return
	var map_instance: Node3D = game_map[map_name].scene.instantiate()
	map_instance.name = game_map[map_name].name
	map_instance.position = game_map[map_name].position
	map_instance.rotation_degrees = game_map[map_name].rotation_degrees
	add_child(map_instance)
