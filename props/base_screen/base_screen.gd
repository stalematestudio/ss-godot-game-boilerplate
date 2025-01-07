class_name BaseScreen extends Area3D

# TODO: rewrite the garbage code from
# https://github.com/godotengine/godot-demo-projects/tree/master/viewport/gui_in_3d

@export var sub_viewport_control_scene: PackedScene = preload("res://props/base_screen_test_scene/center_container.tscn")

## Used for checking if the mouse is inside the Area3D.
var is_mouse_inside := false

## The last processed input touch/mouse event. Used to calculate relative movement.
var last_event_pos2D := Vector2()

## The time of the last event in seconds since engine start.
var last_event_time := -1.0

@onready var display: MeshInstance3D = $display
@onready var sub_viewport: SubViewport = $sub_viewport

func _ready() -> void:
	# var sub_viewport_control = sub_viewport_control_scene.instantiate()
	# sub_viewport.add_child(sub_viewport_control)

	mouse_entered.connect(_mouse_entered_area)
	mouse_exited.connect(_mouse_exited_area)
	input_event.connect(_mouse_input_event)

func _mouse_entered_area() -> void:
	print_debug("_mouse_entered_area")
	is_mouse_inside = true
	# Notify the viewport that the mouse is now hovering it.
	sub_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)


func _mouse_exited_area() -> void:
	print_debug("_mouse_exited_area")
	# Notify the viewport that the mouse is no longer hovering it.
	sub_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)
	is_mouse_inside = false


func _unhandled_input(event: InputEvent) -> void:
	# Check if the event is a non-mouse/non-touch event
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			# If the event is a mouse/touch event, then we can ignore it here, because it will be
			# handled via Physics Picking.
			return
	sub_viewport.push_input(event)


func _mouse_input_event(_camera: Camera3D, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	print_debug("_mouse_input_event")
	# Get mesh size to detect edges and make conversions. This code only supports PlaneMesh and QuadMesh.
	var quad_mesh_size: Vector2 = display.mesh.size

	# Event position in Area3D in world coordinate space.
	var event_pos3D := event_position

	# Current time in seconds since engine start.
	var now := Time.get_ticks_msec() / 1000.0

	# Convert position to a coordinate space relative to the Area3D node.
	# NOTE: `affine_inverse()` accounts for the Area3D node's scale, rotation, and position in the scene!
	event_pos3D = display.global_transform.affine_inverse() * event_pos3D

	# TODO: Adapt to bilboard mode or avoid completely.

	var event_pos2D := Vector2()

	if is_mouse_inside:
		# Convert the relative event position from 3D to 2D.
		event_pos2D = Vector2(event_pos3D.x, -event_pos3D.y)

		# Right now the event position's range is the following: (-quad_size/2) -> (quad_size/2)
		# We need to convert it into the following range: -0.5 -> 0.5
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		# Then we need to convert it into the following range: 0 -> 1
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5

		# Finally, we convert the position to the following range: 0 -> viewport.size
		event_pos2D.x *= sub_viewport.size.x
		event_pos2D.y *= sub_viewport.size.y
		# We need to do these conversions so the event's position is in the viewport's coordinate system.

	elif last_event_pos2D != null:
		# Fall back to the last known event position.
		event_pos2D = last_event_pos2D

	# Set the event's position and global position.
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D

	# Calculate the relative event distance.
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		# If there is not a stored previous position, then we'll assume there is no relative motion.
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		# If there is a stored previous position, then we'll calculate the relative position by subtracting
		# the previous position from the new position. This will give us the distance the event traveled from prev_pos.
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)

	# Update last_event_pos2D with the position we just calculated.
	last_event_pos2D = event_pos2D

	# Update last_event_time to current time.
	last_event_time = now

	# Finally, send the processed input event to the viewport.
	sub_viewport.push_input(event)
