extends StaticBody3D

@onready var mesh = get_node("button")
@onready var material = mesh.get_surface_override_material(0)

func _ready():
	pass 
