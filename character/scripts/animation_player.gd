class_name CharacterAnimationPlayer extends AnimationPlayer

func crouch() -> void:
	play("crouch")

func un_crouch() -> void:
	play_backwards("crouch")

# TODO: jump to crouched or uncrouched so we can load the state