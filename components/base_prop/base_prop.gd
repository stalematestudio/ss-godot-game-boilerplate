class_name BaseProp extends RigidBody3D

# TODO: Implement prop TTL

@export var interactive: bool = true
@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*", "MeshInstance3D")
var interactor: CharacterRayCast3D = null

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
		if _is_grabbed and interactor:
			initial_parent = get_parent()
			reparent(interactor.character_spring_arm_3D)
		else:
			print_debug(name, " initial parent: ", initial_parent)
			if ( not is_instance_valid(initial_parent) ) or ( not initial_parent is PlayArea ):
				initial_parent = Helpers.get_game_manager("maps_manager").active_play_area
			Helpers.reparent_w_renaming(self, initial_parent)
		for geometry_instance in geometry_instances:
			geometry_instance.set_transparency(.75 if _is_grabbed else 0.0)
		if interactor:
			if _is_grabbed:
				add_collision_exception_with(interactor.character_instance)
				interactor.character_instance.ray_cast_3d_obstacle_top.add_exception(self)
				interactor.character_instance.ray_cast_3d_obstacle_bottom.add_exception(self)
				interactor.character_spring_arm_3D.add_excluded_object(get_rid())
			else:
				remove_collision_exception_with(interactor.character_instance)
				interactor.character_instance.ray_cast_3d_obstacle_top.remove_exception(self)
				interactor.character_instance.ray_cast_3d_obstacle_bottom.remove_exception(self)
				interactor.character_spring_arm_3D.remove_excluded_object(get_rid())

var rotate_vector: Vector2 = Vector2()

var grab_distance: float:
	get:
		return grab_distance
	set(new_grab_distance):
		grab_distance = clamp(new_grab_distance, 0.5, 1)
		if is_instance_valid(interactor):
			interactor.character_spring_arm_3D.spring_length = grab_distance

var primary_action: String:
	get:
		return "DROP" if is_grabbed else "GRAB"

var secondary_action: String:
	get:
		return "THROW" if is_grabbed else "PUSH"

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_props"):
		add_to_group("game_objects_props", true)
	if is_inside_tree() and not is_in_group("game_objects_savable"):
		add_to_group("game_objects_savable", true)

	mouse_entered.connect(highlight)
	mouse_exited.connect(un_highlight)

func _physics_process(_delta: float) -> void:
	if not is_grabbed:
		return
	if not Input.is_action_pressed("player_mode_action"):
		return

	rotate_vector = PlayerUtils.get_look_vector()

	rotate_x(deg_to_rad( rotate_vector.y ))
	rotate_y(deg_to_rad( rotate_vector.x ))

func activate(new_interactor: CharacterRayCast3D) -> void:
	if not interactive or is_grabbed:
		return
	highlight()
	interactor = new_interactor
	if not interactor.raycast_target_changed.is_connected(_on_interactor_raycast_target_changed):
		interactor.raycast_target_changed.connect(_on_interactor_raycast_target_changed)
	if not interactor.raycast_primary_action.is_connected(_on_interactor_raycast_primary_action):
		interactor.raycast_primary_action.connect(_on_interactor_raycast_primary_action)
	if not interactor.raycast_secondary_action.is_connected(_on_interactor_raycast_secondary_action):
		interactor.raycast_secondary_action.connect(_on_interactor_raycast_secondary_action)
	if not interactor.raycast_in_action.is_connected(_on_interactor_raycast_in_action):	
		interactor.raycast_in_action.connect(_on_interactor_raycast_in_action)
	if not interactor.raycast_out_action.is_connected(_on_interactor_raycast_out_action):
		interactor.raycast_out_action.connect(_on_interactor_raycast_out_action)

func deactivate() -> void:
	if is_grabbed:
		return
	un_highlight()
	if interactor:
		if interactor.raycast_target_changed.is_connected(_on_interactor_raycast_target_changed):
			interactor.raycast_target_changed.disconnect(_on_interactor_raycast_target_changed)
		if interactor.raycast_primary_action.is_connected(_on_interactor_raycast_primary_action):
			interactor.raycast_primary_action.disconnect(_on_interactor_raycast_primary_action)
		if interactor.raycast_secondary_action.is_connected(_on_interactor_raycast_secondary_action):
			interactor.raycast_secondary_action.disconnect(_on_interactor_raycast_secondary_action)
		if interactor.raycast_in_action.is_connected(_on_interactor_raycast_in_action):
			interactor.raycast_in_action.disconnect(_on_interactor_raycast_in_action)
		if interactor.raycast_out_action.is_connected(_on_interactor_raycast_out_action):
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
	if interactor and is_grabbed:
		grab_distance -= 0.1

func _on_interactor_raycast_out_action() -> void:
	if interactor and is_grabbed:
		grab_distance += 0.1

func get_grabbed() -> void:
	if interactor:
		is_grabbed = true
		grab_distance = interactor.raycast_target_distance
		interactor.raycast_target = null

func get_dropped() -> void:
	if interactor:
		is_grabbed = false

func get_thrown() -> void:
	if interactor:
		is_grabbed = false
		apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

func get_pushed() -> void:
	if interactor:
		apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

func highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func un_highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()

func save_data() -> Dictionary:
	return {
	"name": name,
	"scene": get_scene_file_path(),
	"position": position,
	"rotation":	rotation,
	"angular_velocity": angular_velocity,
	"linear_velocity": linear_velocity,
	}

func load_data(data: Dictionary) -> void:
	name = data.name
	position = Helpers.string_to_vector(data.position) if data.position is String else data.position
	rotation = Helpers.string_to_vector(data.rotation) if data.rotation is String else data.rotation
	angular_velocity = Helpers.string_to_vector(data.angular_velocity) if data.angular_velocity is String else data.angular_velocity
	linear_velocity = Helpers.string_to_vector(data.linear_velocity) if data.linear_velocity is String else data.linear_velocity
