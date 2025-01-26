class_name CharacterAnimationPlayer extends AnimationPlayer

func crouch() -> void:
	play("crouch")

func un_crouch() -> void:
	play_backwards("crouch")

func imediate_crouch() -> void:
	play("crouch", -1, 100, false)

func imediate_un_crouch() -> void:
	play("crouch", -1, -100, true)
