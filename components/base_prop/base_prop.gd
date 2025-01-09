class_name BaseProp extends RigidBody3D

@export var interactive: bool = true
@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*")
var interactor: PlayerRayCast3D = null

@onready var initial_parent: Node = get_parent()
@onready var geometry_instances: Array[Node] = find_children("*", "GeometryInstance3D")

var _is_grabbed: bool = false
var is_grabbed: bool:
	get:
		return _is_grabbed
	set(new_is_grabbed):
		if _is_grabbed == new_is_grabbed:
			return
		_is_grabbed = new_is_grabbed
		freeze = _is_grabbed
		reparent(interactor.spring_arm_3d if _is_grabbed else initial_parent)
		for geometry_instance in geometry_instances:
			geometry_instance.set_transparency(.75 if _is_grabbed else 0.0)
		if _is_grabbed:
			add_collision_exception_with(interactor.player_instance)
			interactor.spring_arm_3d.add_excluded_object(get_rid())
		else:
			remove_collision_exception_with(interactor.player_instance)
			interactor.spring_arm_3d.remove_excluded_object(get_rid())


var rotate_vector: Vector2 = Vector2()

var grab_distance: float:
	get:
		return grab_distance
	set(new_grab_distance):
		grab_distance = clamp(new_grab_distance, 0.5, 1)
		if is_instance_valid(interactor):
			interactor.spring_arm_3d.spring_length = grab_distance

var primary_action: String:
	get:
		return "DROP" if is_grabbed else "GRAB"

var secondary_action: String:
	get:
		return "THROW" if is_grabbed else "PUSH"

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_props"):
		add_to_group("game_objects_props", true)

	sleeping_state_changed.connect(_on_sleeping_state_changed)
	mouse_entered.connect(highlight)
	mouse_exited.connect(un_highlight)

func _physics_process(_delta: float) -> void:
	if not is_grabbed:
		return

	# global_transform.origin = interactor.global_transform.origin + ( interactor.global_transform.basis.z.normalized() * grab_distance )

	if not Input.is_action_pressed("player_mode_action"):
		return

	rotate_vector = Input.get_vector("player_look_right", "player_look_left", "player_look_up", "player_look_down")

	if ConfigManager.config_data.controller.right_y_inverted:
		rotate_vector.y = rotate_vector.y * -1
	
	if ConfigManager.config_data.controller.right_x_inverted:
		rotate_vector.x = rotate_vector.x * -1

	rotate_x(deg_to_rad( rotate_vector.y * ConfigManager.config_data.controller.right_y_sensitivity ))
	rotate_y(deg_to_rad( rotate_vector.x * ConfigManager.config_data.controller.right_x_sensitivity ))
	
func _input(event: InputEvent) -> void:
	if not is_grabbed:
		return
	if not event is InputEventMouseMotion:
		return
	if not Input.is_action_pressed("player_mode_action"):
		return

	if ConfigManager.config_data.mouse.mouse_inverted_y:
		rotate_x(deg_to_rad(event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y * -1))
	else:
		rotate_x(deg_to_rad(event.screen_relative.y * ConfigManager.config_data.mouse.mouse_sensitivity_y))
	
	if ConfigManager.config_data.mouse.mouse_inverted_x:
		rotate_y(deg_to_rad(event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x))
	else:
		rotate_y(deg_to_rad(event.screen_relative.x * ConfigManager.config_data.mouse.mouse_sensitivity_x * -1))

func activate(new_interactor: PlayerRayCast3D) -> void:
	if not interactive or is_grabbed:
		return
	highlight()
	interactor = new_interactor
	interactor.raycast_target_changed.connect(_on_interactor_raycast_target_changed)
	interactor.raycast_primary_action.connect(_on_interactor_raycast_primary_action)
	interactor.raycast_secondary_action.connect(_on_interactor_raycast_secondary_action)
	interactor.raycast_in_action.connect(_on_interactor_raycast_in_action)
	interactor.raycast_out_action.connect(_on_interactor_raycast_out_action)

func deactivate() -> void:
	if is_grabbed:
		return
	un_highlight()
	interactor.raycast_target_changed.disconnect(_on_interactor_raycast_target_changed)
	interactor.raycast_primary_action.disconnect(_on_interactor_raycast_primary_action)
	interactor.raycast_secondary_action.disconnect(_on_interactor_raycast_secondary_action)
	interactor.raycast_in_action.disconnect(_on_interactor_raycast_in_action)
	interactor.raycast_out_action.disconnect(_on_interactor_raycast_out_action)
	interactor = null

func _on_interactor_raycast_target_changed(new_target: Node) -> void:
	if self == new_target:
		return
	if is_grabbed:
		interactor.raycast_target = self
	deactivate()

func _on_interactor_raycast_primary_action() -> void:
	match primary_action:
		"GRAB":
			get_grabbed()
		"DROP":
			get_dropped()

func _on_interactor_raycast_secondary_action() -> void:
	match secondary_action:
		"THROW":
			get_thrown()
		"PUSH":
			get_pushed()

func _on_interactor_raycast_in_action() -> void:
	if is_grabbed:
		grab_distance -= 0.1

func _on_interactor_raycast_out_action() -> void:
	if is_grabbed:
		grab_distance += 0.1

func _on_sleeping_state_changed() -> void:
	print_debug(name, " - ", sleeping)

func get_grabbed() -> void:
	is_grabbed = true
	grab_distance = interactor.raycast_target_distance
	interactor.raycast_target = null

func get_dropped() -> void:
	is_grabbed = false

func get_thrown() -> void:
	is_grabbed = false
	apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

func get_pushed() -> void:
	apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

func highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func un_highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()
