class_name CharacterRayCast3D extends RayCast3D

@onready var character_instance: Character = get_parent().get_parent()
@onready var spring_arm_3d: SpringArm3D = $character_spring_arm_3D

var _raycast_target: Node
var raycast_target: Node:
	get:
		return _raycast_target
	set(new_raycast_target):
		if _raycast_target == new_raycast_target:
			return
		if is_instance_valid(_raycast_target):
			if _raycast_target.has_method("_mouse_exited_area"):
				_raycast_target._mouse_exited_area()
		_raycast_target = new_raycast_target
		raycast_target_changed.emit(_raycast_target)
		if is_instance_valid(_raycast_target):
			if _raycast_target.has_method("_mouse_entered_area"):
				_raycast_target._mouse_entered_area()
			if raycast_target.has_method("activate"):
				raycast_target.activate(self)

var raycast_target_distance: float = 0.0
var raycast_collision_point: Vector3 = Vector3()

const OBJECT_INTERACT_DISTANCE: float = 1.5
const OBJECT_GRAB_MAX_MASS: float = 0.5
const OBJECT_THROW_FORCE: float = 10

var active_screen: Node

signal raycast_target_changed
signal raycast_primary_action
signal raycast_secondary_action
signal raycast_mode_action
signal raycast_in_action
signal raycast_out_action

func _ready() -> void:
	add_exception(character_instance)

func _process(_delta: float) -> void:
	if is_colliding():
		raycast_target = get_collider()
		raycast_collision_point = get_collision_point()
		raycast_target_distance = get_global_transform().origin.distance_to(raycast_collision_point)
	else:
		raycast_target = null
		raycast_collision_point = Vector3()
		raycast_target_distance = float()
