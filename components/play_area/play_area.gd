class_name PlayArea extends Area3D

# Collision layers: triggers / mask: characters props

@onready var maps_manager: MapsManager = get_parent()

var _game_objects_savable: Array[Node]
var game_objects_savable: Array[Node]:
	get:
		_game_objects_savable.clear()
		for child in get_children(true):
			if child.is_in_group("game_objects_savable"):
				_game_objects_savable.append(child)
		return _game_objects_savable

func _ready() -> void:
	if is_inside_tree() and not is_in_group("play_areas"):
		add_to_group("play_areas", true)

	load_data()

	# The body entered addoption model crashes the game unless there is a buffer between areas.
	# body_entered.connect(body_handler)
	tree_exiting.connect(save_data)

var scan_map_interval: float = 1.0
var scan_map_time: float = scan_map_interval

func _process(delta: float) -> void:
	scan_map_time -= delta
	if scan_map_time > 0.0:
		return
	scan_map_time = scan_map_interval

	for body in get_overlapping_bodies():
		body_handler(body)

func adopt_game_objects_savable(objects_savable: Node) -> void:
	print_debug(name, " adopting ", objects_savable.name)
	Helpers.reparent_w_renaming(objects_savable, self)

func save_data() -> void:
	var game_objects_data_list: Array = []
	for game_object in game_objects_savable:
		game_objects_data_list.append(game_object.save_data())
	maps_manager.game.game_data[name] = game_objects_data_list

func load_data() -> void:
	if not maps_manager.game.game_data.has(name):
		return
	for child in get_children():
		if child.is_in_group("game_objects_savable"):
			child.free()
	for game_object in maps_manager.game.game_data[name]:
		var game_object_instance = load(game_object.scene).instantiate()
		add_child(game_object_instance)
		game_object_instance.load_data(game_object)

func body_handler(body: Node3D) -> void:
	if ( body is Character ) and ( body.is_player_controlled ):
			maps_manager.level_active = name

	if ( body is Character ) and ( not body in game_objects_savable ):
		adopt_game_objects_savable(body)

	if ( body is BaseProp ) and ( not body._is_grabbed ) and ( not body in game_objects_savable ):
		adopt_game_objects_savable(body)
