class_name PlayerAnimationPlayer extends AnimationPlayer

func crouch() -> void:
	play("crouch")

func un_crouch() -> void:
	play_backwards("crouch")
