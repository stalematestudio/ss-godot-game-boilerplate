class_name BaseScreen extends Area3D

@export var interactive: bool = true
var primary_action: String = "PRESS"
var secondary_action: String = "INTERACT"

@export var sub_viewport_control_scene: PackedScene
@onready var sub_viewport_control: Control

var is_mouse_inside := false

var event_pos2D: Vector2 = Vector2()
var last_event_pos2D: Vector2 = Vector2()

var now: float = float()
var last_event_time: float = -1.0

var event_pos3D: Vector3 = Vector3()

@onready var display: MeshInstance3D = $display
@onready var display_size: Vector2 = display.mesh.size

@onready var sub_viewport: SubViewport = $sub_viewport
@onready var sub_viewport_size: Vector2i = sub_viewport.size

signal mouse_entered_area
signal mouse_exited_area


func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_props"):
		add_to_group("game_objects_controls", true)

	sub_viewport_control = sub_viewport_control_scene.instantiate()
	sub_viewport_control.display_parent = get_parent()
	sub_viewport.add_child(sub_viewport_control)

	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	input_event.connect(on_mouse_input_event)

func on_mouse_entered() -> void:
	is_mouse_inside = true
	sub_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)
	mouse_entered_area.emit()

func on_mouse_exited() -> void:
	sub_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false
	mouse_exited_area.emit()
	sub_viewport_control.hide()
	sub_viewport_control.show()
	last_event_pos2D = Vector2()
	last_event_time= -1.0

func on_mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	now = Time.get_ticks_msec() / 1000.0
	event_pos2D = Vector2()
	event_pos3D = display.global_transform.affine_inverse() * event_position

	if is_mouse_inside:
		event_pos2D = Vector2(
			event_pos3D.x / display_size.x,
			-event_pos3D.y / display_size.y,
		)
		event_pos2D.x += 0.5
		event_pos2D.x *= sub_viewport_size.x
		event_pos2D.y += 0.5
		event_pos2D.y *= sub_viewport_size.y
	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D

	event.position = event_pos2D

	if event is InputEventMouse:
		event.global_position = event_pos2D

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	last_event_pos2D = event_pos2D
	last_event_time = now

	sub_viewport.push_input(event)
