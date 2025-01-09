class_name BaseDoor extends AnimatableBody3D

@export var interactive: bool = true

@onready var outline_mesh_array: Array[Node] = find_children("outline_mesh*")
@onready var animation: AnimationPlayer = $animation_player

@export var is_open: bool = false

var primary_action: String:
	get:
		return "CLOSE" if is_open else "OPEN"

var secondary_action: String = ""

func _ready() -> void:
	if is_inside_tree() and not is_in_group("game_objects_doors"):
		add_to_group("game_objects_doors", true)
	if is_open == true:
		animation.play("open")

func do_primary() -> void:
	if animation.is_playing():
		return
	if is_open:
		is_open = false
		animation.play_backwards("open")
	else:
		is_open = true
		animation.play("open")

func do_secondary() -> void:
	pass

func highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.show()

func un_highlight() -> void:
	for outline_mesh in outline_mesh_array:
		outline_mesh.hide()
