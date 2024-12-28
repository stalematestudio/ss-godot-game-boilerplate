class_name PlayerRayCast3D extends RayCast3D

var raycast_target = false
var raycast_target_distance = false

const OBJECT_THROW_FORCE = 1
const OBJECT_GRAB_DISTANCE = 2

var grabbed_object = null
var grabbed_object_distance = 0.5

func _process(_delta: float) -> void:
	process_input()
	process_ray_cast()

func process_input():
	# Grabbin and throwing objects
	if Input.is_action_just_pressed("player_primary_action"):
		if ( grabbed_object == null ) and ( is_colliding() ) and ( raycast_target is RigidBody3D ) and ( raycast_target_distance < OBJECT_GRAB_DISTANCE ) :
			grabbed_object = raycast_target
			grabbed_object_distance = raycast_target_distance
			# add_collision_exception_with(grabbed_object)
		elif grabbed_object != null:
			grabbed_object.apply_central_impulse(global_transform.basis.z.normalized() * OBJECT_THROW_FORCE)
			# remove_collision_exception_with(grabbed_object)
			grabbed_object = null
	
	# Holding object
	if grabbed_object != null:
		grabbed_object.global_transform.origin = global_transform.origin + ( global_transform.basis.z.normalized() * grabbed_object_distance )

func process_ray_cast():
	if is_colliding():
		raycast_target = get_collider()
		raycast_target_distance = get_global_transform().origin.distance_to(get_collision_point())
	else:
		raycast_target = false
		raycast_target_distance = false
