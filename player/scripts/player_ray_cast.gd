class_name PlayerRayCast3D extends RayCast3D

var player_manager: PlayerManager
var player_camera: Camera3D

var _raycast_target: Node
var raycast_target: Node:
	get:
		return _raycast_target
	set(new_raycast_target):
		if _raycast_target == new_raycast_target:
			return
		if _raycast_target:
			if _raycast_target.has_method("un_highlight_interactible"):
				_raycast_target.un_highlight_interactible()
			if _raycast_target.has_method("_mouse_exited_area"):
				_raycast_target._mouse_exited_area()
		_raycast_target = new_raycast_target
		raycast_target_changed.emit(_raycast_target)
		if _raycast_target:
			if _raycast_target.has_method("highlight_interactible"):
				_raycast_target.highlight_interactible()
			if _raycast_target.has_method("_mouse_entered_area"):
				_raycast_target._mouse_entered_area()

var raycast_target_distance: float = 0.0
var raycast_collision_point: Vector3 = Vector3()

const OBJECT_GRAB_DISTANCE: float = 1.5
const OBJECT_GRAB_MAX_MASS: float = 0.5
const OBJECT_THROW_FORCE: float = 0.5

var grabbed_object: Node
var grabbed_object_distance = OBJECT_GRAB_DISTANCE

const OBJECT_PRESS_DISTANCE: float = 1.3

var active_screen: Node

@onready var player_instance: PlayerCharacter = get_node("/root/main/game/player_manager/player_character")

signal raycast_target_changed

func _process(_delta: float) -> void:
	if is_colliding():
		raycast_target = get_collider()
		raycast_collision_point = get_collision_point()
		raycast_target_distance = get_global_transform().origin.distance_to(raycast_collision_point)
	else:
		raycast_target = null
		raycast_collision_point = Vector3()
		raycast_target_distance = float()

	# Holding object
	if is_instance_valid(grabbed_object):
		grabbed_object.global_transform.origin = global_transform.origin + ( global_transform.basis.z.normalized() * grabbed_object_distance )

func _input(event: InputEvent) -> void:
	if ( raycast_target is BaseScreen ) and ( raycast_target_distance < OBJECT_PRESS_DISTANCE ):
		active_screen = raycast_target
		if ( event is InputEventMouse ):
			if active_screen.has_method("_mouse_input_event"):
				active_screen._mouse_input_event(player_camera, event, raycast_collision_point, Vector3(), int())
		if event.is_action_pressed("player_secondary_action") and active_screen.has_signal("mouse_exited_area"):
			player_manager.interaction_mouse()
			active_screen.mouse_exited_area.connect(_on_interaction_end)
	elif event.is_action_pressed("player_primary_action") and raycast_target:
		# Grabbin and throwing objects
		if grabbed_object != null:
			grabbed_object.apply_central_impulse(global_transform.basis.z.normalized() * OBJECT_THROW_FORCE)
			player_instance.remove_collision_exception_with(grabbed_object)
			grabbed_object.is_grabbed = false
			grabbed_object = null
		elif ( raycast_target is BaseProp ) and ( raycast_target_distance < OBJECT_GRAB_DISTANCE ) and ( raycast_target.mass <= OBJECT_GRAB_MAX_MASS ):
			grabbed_object = raycast_target
			grabbed_object_distance = raycast_target_distance
			player_instance.add_collision_exception_with(grabbed_object)
			grabbed_object.is_grabbed = true
			raycast_target = null

func _on_interaction_end() -> void:
	active_screen.mouse_exited_area.disconnect(_on_interaction_end)
	active_screen = null
	player_manager.interaction_ray_cast()

func interaction_action(action_name: String) -> void:
	match action_name:
		"GRAB":
			pass
		"PUSH":
			pass
		"DROP":
			pass
		"THROW":
			pass
		"PRESS":
			pass
		"INTERACT":
			pass
		_:
			pass
