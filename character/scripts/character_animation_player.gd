class_name CharacterAnimationPlayer extends AnimationPlayer

func crouch() -> void:
	play("crouch")

func un_crouch() -> void:
	play_backwards("crouch")

func imediate_crouch() -> void:
	set_current_animation("crouch")
	seek(current_animation.length(), true)

func imediate_un_crouch() -> void:
	set_current_animation("crouch")
	seek(0, true)
