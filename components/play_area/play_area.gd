class_name PlayArea extends Area3D

@onready var maps_manager: MapsManager = get_parent()
@onready var props_parent: Node3D = find_child("props_parent", false)
@onready var props_list: Array[Node] = props_parent.get_children(false)

func _ready():
	body_entered.connect(_on_body_entered)

var scan_map_interval: float = 1.0
var scan_map_time: float = scan_map_interval

func _physics_process(delta: float) -> void:
	scan_map_time -= delta
	if scan_map_time > 0.0:
		return
	scan_map_time = scan_map_interval

	for body in get_overlapping_bodies():
		if ( body is BaseProp ) and ( not body in props_list ):
			Helpers.reparent_w_renaming(body, props_parent)
			props_list = props_parent.get_children()

func _on_body_entered(body: Node3D) -> void:
	if body is PlayerCharacter:
		maps_manager.level_active = name

func adopt_prop(prop: BaseProp) -> void:
	Helpers.reparent_w_renaming(prop, props_parent)
	props_list = props_parent.get_children()

func unload() -> void:
	print_debug("unloading: ", name)
	queue_free()
