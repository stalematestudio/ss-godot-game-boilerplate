class_name BaseProp extends RigidBody3D

# TODO:
# Implement prop TTL
# Grabing and throwing should depend on character strength
# Grabing an object should change character speed.

@export var interactive: bool = true
@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*", "MeshInstance3D")

@onready var initial_parent: Node = get_parent()
@onready var geometry_instances: Array[Node] = find_children("*", "GeometryInstance3D")

var is_grabbed: bool = false

var rotate_vector: Vector2 = Vector2()

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

	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func on_mouse_exited() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()

func call_primary_action(character: Character, interactor: CharacterRayCast3D) -> void:
	match primary_action:
		"GRAB":
			get_grabbed(character, interactor)
		"DROP":
			get_dropped(character, interactor)

func call_secondary_action(character: Character, interactor: CharacterRayCast3D) -> void:
	match secondary_action:
		"THROW":
			get_thrown(character, interactor)
		"PUSH":
			get_pushed(character, interactor)

func call_mode_action(_character: Character, _interactor: CharacterRayCast3D, input_vector: Vector2) -> void:
	if is_grabbed:
		rotate_x(deg_to_rad( input_vector.y ))
		rotate_y(deg_to_rad( input_vector.x ))

func call_in_action(_character: Character, interactor: CharacterRayCast3D) -> void:
	interactor.character_spring_arm_3D.spring_length = clamp(
		interactor.character_spring_arm_3D.spring_length - 0.1,
		0.5,
		1
	)

func call_out_action(_character: Character, interactor: CharacterRayCast3D) -> void:
	interactor.character_spring_arm_3D.spring_length = clamp(
		interactor.character_spring_arm_3D.spring_length + 0.1,
		0.5,
		1
	)

func get_grabbed(character: Character, interactor: CharacterRayCast3D) -> void:
	is_grabbed = true

	freeze = true

	initial_parent = get_parent()
	reparent(interactor.character_spring_arm_3D)

	for geometry_instance in geometry_instances:
		geometry_instance.set_transparency(.75)

	add_collision_exception_with(character)
	character.ray_cast_3d_obstacle_top.add_exception(self)
	character.ray_cast_3d_obstacle_bottom.add_exception(self)
	interactor.character_spring_arm_3D.add_excluded_object(get_rid())

	interactor.character_spring_arm_3D.spring_length = interactor.target_distance
	interactor.target = null

func get_dropped(character: Character, interactor: CharacterRayCast3D) -> void:
	is_grabbed = false

	freeze = false

	if ( not is_instance_valid(initial_parent) ) or ( not initial_parent is PlayArea ):
		initial_parent = Helpers.get_game_manager("maps_manager").active_play_area
	Helpers.reparent_w_renaming(self, initial_parent)

	for geometry_instance in geometry_instances:
		geometry_instance.set_transparency(0.0)

	remove_collision_exception_with(character)
	character.ray_cast_3d_obstacle_top.remove_exception(self)
	character.ray_cast_3d_obstacle_bottom.remove_exception(self)
	interactor.character_spring_arm_3D.remove_excluded_object(get_rid())

func get_thrown(character: Character, interactor: CharacterRayCast3D) -> void:
	get_dropped(character, interactor)
	apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

func get_pushed(_character: Character, interactor: CharacterRayCast3D) -> void:
	apply_central_impulse(interactor.global_transform.basis.z.normalized() * 5)

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
