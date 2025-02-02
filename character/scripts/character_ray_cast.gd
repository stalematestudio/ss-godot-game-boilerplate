class_name CharacterRayCast3D extends RayCast3D

@onready var character_instance: Character = get_parent().get_parent()
@onready var character_spring_arm_3D: CharacterSpringArm3D = get_parent().get_node("character_spring_arm_3D")

var collision_point: Vector3 = Vector3()
var target_distance: float = float()

var _target: Node
var target: Node:
	get:
		return _target
	set(new_target):
		if _target == new_target:
			return

		if is_instance_valid(_target):
			if _target.has_method("on_mouse_exited"):
				_target.on_mouse_exited()

		_target = new_target
		target_changed.emit(_target)

		if is_instance_valid(_target):
			if _target.has_method("on_mouse_entered"):
				_target.on_mouse_entered()

const OBJECT_INTERACT_DISTANCE: float = 1.5
const OBJECT_GRAB_MAX_MASS: float = 0.5
const OBJECT_THROW_FORCE: float = 10

var active_screen: Node

signal target_changed

func _ready() -> void:
	add_exception(character_instance)

# func _physics_process(_delta: float) -> void:
func _process(_delta: float) -> void:
	if is_colliding():
		target = get_collider()
		collision_point = get_collision_point()
		target_distance = get_global_transform().origin.distance_to(collision_point)
	else:
		target = null
		collision_point = Vector3()
		target_distance = float()

func primary_action() -> void:
	if target and target.has_method("call_primary_action"):
		target.call_primary_action(character_instance, self)

func secondary_action() -> void:
	if target and target.has_method("call_secondary_action"):
		target.call_secondary_action(character_instance, self)

func mode_action(input_vector: Vector2) -> void:
	if target and target.has_method("call_mode_action"):
		target.call_mode_action(character_instance, self, input_vector)

func in_action() -> void:
	if target and target.has_method("call_in_action"):
		target.call_in_action(character_instance, self)

func out_action() -> void:
	if target and target.has_method("call_out_action"):
		target.call_out_action(character_instance, self)
