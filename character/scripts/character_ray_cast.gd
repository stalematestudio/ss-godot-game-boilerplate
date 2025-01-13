class_name CharacterRayCast3D extends RayCast3D

var character_instance: Character
var character_camera: CharacterCamera3D

@onready var spring_arm_3d: SpringArm3D = $character_spring_arm_3D

var _mouse_mode_current: String = "ray_cast"
var mouse_mode_current: String:
	get:
		return _mouse_mode_current
	set(new_mouse_mode):
		if not new_mouse_mode in ["ray_cast", "mouse"]:
			return
		_mouse_mode_current = new_mouse_mode
		match new_mouse_mode:
			"ray_cast":
				enabled = true
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			"mouse":
				enabled = false
				raycast_target = null
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

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

func _unhandled_input(event: InputEvent) -> void:
	if not is_instance_valid(raycast_target):
		return
	if raycast_target_distance > OBJECT_INTERACT_DISTANCE:
		return
	if not "interactive" in raycast_target:
		return
	if not raycast_target.interactive:
		return

	if raycast_target is BaseScreen:
		active_screen = raycast_target
		if ( event is InputEventMouse ):
			if active_screen.has_method("_mouse_input_event"):
				active_screen._mouse_input_event(character_camera, event, raycast_collision_point, Vector3(), int())
		if event.is_action_pressed("player_secondary_action") and active_screen.has_signal("mouse_exited_area"):
			mouse_mode_current = "mouse"
			active_screen.mouse_exited_area.connect(_on_interaction_end)
		return

	if ( raycast_target is BaseProp ) or ( raycast_target is BaseDoor ):
		if event.is_action_pressed("player_primary_action"):
			raycast_primary_action.emit()
		elif event.is_action_pressed("player_secondary_action"):
			raycast_secondary_action.emit()
		elif event.is_action_pressed("player_mode_action"):
			raycast_mode_action.emit()
		elif event.is_action_pressed("player_in_action"):
			raycast_in_action.emit()
		elif event.is_action_pressed("player_out_action"):
			raycast_out_action.emit()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_released("mouse_mode_switch"):
		match mouse_mode_current:
			"ray_cast":
				mouse_mode_current = "mouse"
			"mouse":
				mouse_mode_current = "ray_cast"

func _on_interaction_end() -> void:
	active_screen.mouse_exited_area.disconnect(_on_interaction_end)
	active_screen = null
	mouse_mode_current = "ray_cast"
