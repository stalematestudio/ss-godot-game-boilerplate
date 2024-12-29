class_name PlayerRayCast3D extends RayCast3D

var raycast_target: Node
var raycast_target_distance: float = 0.0

const OBJECT_THROW_FORCE: float = 0.5
const OBJECT_GRAB_DISTANCE: float = 2.0
const OBJECT_GRAB_MAX_MASS: float = 0.5

var grabbed_object: Node
var grabbed_object_distance = OBJECT_GRAB_DISTANCE

@onready var player_instance: PlayerCharacter = get_node_or_null("/root/main/game/player_character")

func _process(_delta: float) -> void:
	if is_colliding():
		raycast_target = get_collider()
		raycast_target_distance = get_global_transform().origin.distance_to(get_collision_point())
	else:
		raycast_target = null
		raycast_target_distance = float()

	# Holding object
	if grabbed_object != null:
		grabbed_object.global_transform.origin = global_transform.origin + ( global_transform.basis.z.normalized() * grabbed_object_distance )

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("player_primary_action") and raycast_target:
		# Grabbin and throwing objects
		if grabbed_object != null:
			grabbed_object.apply_central_impulse(global_transform.basis.z.normalized() * OBJECT_THROW_FORCE)
			player_instance.remove_collision_exception_with(grabbed_object)
			grabbed_object = null
		elif ( raycast_target is RigidBody3D ) and ( raycast_target_distance < OBJECT_GRAB_DISTANCE ) and ( raycast_target.mass <= OBJECT_GRAB_MAX_MASS ):
			grabbed_object = raycast_target
			grabbed_object_distance = raycast_target_distance
			player_instance.add_collision_exception_with(grabbed_object)
