class_name PropsParent extends Node3D

@onready var play_area: PlayArea = get_parent()
@onready var props_manager: PropsManager = Helpers.get_game_manager("props_manager")

var _prop_list: Array[BaseProp]
var prop_list: Array[BaseProp]:
	get:
		_prop_list.clear()
		for child in get_children(false):
			if child is BaseProp:
				_prop_list.append(child)
		return _prop_list

var scan_map_interval: float = 1.0
var scan_map_time: float = scan_map_interval

func _ready() -> void:
	if is_inside_tree() and not is_in_group("props_parents"):
		add_to_group("props_parents", true)
	tree_exiting.connect(_on_tree_exiting)
	if props_manager.props_data.has(play_area.name):
		load_data(props_manager.props_data[play_area.name])

func _physics_process(delta: float) -> void:
	scan_map_time -= delta
	if scan_map_time > 0.0:
		return
	scan_map_time = scan_map_interval

	for body in play_area.get_overlapping_bodies():
		if ( body is BaseProp ) and ( not body in prop_list ):
			adopt_prop(body)

func adopt_prop(prop: BaseProp) -> void:
	Helpers.reparent_w_renaming(prop, self)

func save_data() -> Array:
	var props_data_list: Array = []
	for prop in prop_list:
		props_data_list.append(prop.save_data())
	return props_data_list

func load_data(props: Array = Array()) -> void:
	for child in get_children():
		if child is BaseProp:
			child.queue_free()
	for prop in props:
		var prop_instance = load(prop.scene).instantiate()
		prop_instance.load_data(prop)
		add_child(prop_instance)
		# Looks like the name can only be set after the node enters the sceen
		prop_instance.name = prop.name	

func _on_tree_exiting() -> void:
	props_manager.props_data[play_area.name] = save_data()
