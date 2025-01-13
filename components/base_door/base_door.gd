class_name BaseDoor extends AnimatableBody3D

@export var interactive: bool = true
@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*")
var interactor: CharacterRayCast3D = null

@onready var animation: AnimationPlayer = $animation_player

@export var is_open: bool = false

var primary_action: String:
	get:
		return "CLOSE" if is_open else "OPEN"

var secondary_action: String = ""

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_doors"):
		add_to_group("game_objects_doors", true)
	
	animation.assigned_animation = "open"
	if is_open == true:
		animation.play("open")

func activate(new_interactor: CharacterRayCast3D) -> void:
	if not interactive:
		return
	highlight()
	interactor = new_interactor
	interactor.raycast_target_changed.connect(_on_interactor_raycast_target_changed)
	interactor.raycast_primary_action.connect(_on_interactor_raycast_primary_action)
	interactor.raycast_in_action.connect(_on_interactor_raycast_in_action)
	interactor.raycast_out_action.connect(_on_interactor_raycast_out_action)

func deactivate() -> void:
	un_highlight()
	interactor.raycast_target_changed.disconnect(_on_interactor_raycast_target_changed)
	interactor.raycast_primary_action.disconnect(_on_interactor_raycast_primary_action)
	interactor.raycast_in_action.disconnect(_on_interactor_raycast_in_action)
	interactor.raycast_out_action.disconnect(_on_interactor_raycast_out_action)
	interactor = null

func _on_interactor_raycast_target_changed(new_target: Node) -> void:
	if self == new_target:
		return
	deactivate()

func _on_interactor_raycast_primary_action() -> void:
	if animation.is_playing():
		return
	if is_open:
		is_open = false
		animation.play_backwards("open")
	else:
		is_open = true
		animation.play("open")
	interactor.raycast_target = null

func _on_interactor_raycast_in_action() -> void:
	increment_door(-0.05)

func _on_interactor_raycast_out_action() -> void:
	increment_door(0.05)

func increment_door(step: float) -> void:
	if animation.is_playing():
		return
	animation.seek(animation.current_animation_position+step, true)
	is_open = animation.current_animation_position != 0
	interactor.raycast_target = null

func highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func un_highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()
