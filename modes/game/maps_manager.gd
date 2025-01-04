class_name MapsManager extends Node

var game_map: Dictionary = {
	"demo_1": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_1",
		"position": Vector3(),
		"rotation": Vector3(),
		"neightbours": ["demo_2"]
		},
	"demo_2": {
		"scene": preload("res://level/demo/demo.tscn"),
		"name": "demo_2",
		"position": Vector3(160,0,0),
		"rotation": Vector3(),
		"neightbours": ["demo_1"]
		},
}

var level_active: String = "demo_1"
var levels_loaded: PackedStringArray = ["demo_1", "demo_2"]

func save_data() -> Dictionary:
	return {
		"maps": {
			"level_active": level_active,
			"levels_loaded": levels_loaded,
		}
	}

func load_data(maps: Dictionary = Dictionary()) -> void:
	if maps:
		level_active = maps.level_active
	instantiate_maps()

func instantiate_maps() -> void:
	levels_loaded = [level_active]
	levels_loaded.append_array(game_map[level_active].neightbours)
	for level in levels_loaded:
		if not find_child(level):
			instantiate_map(level)
	for level in get_children():
		if not level.name in levels_loaded:
			level.queue_free()

func instantiate_map(map_name: String) -> void:
	var map_instance: Node3D = game_map[map_name].scene.instantiate()
	map_instance.name = game_map[map_name].name
	map_instance.position = game_map[map_name].position
	map_instance.rotation = game_map[map_name].rotation
	add_child(map_instance)
