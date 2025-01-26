class_name CharacterSpotLight3D extends SpotLight3D

var on: bool:
	get:
		return visible
	set(new_on):
		if new_on:
			show()
		else:
			hide()

func toggle() -> void:
	on = not on
