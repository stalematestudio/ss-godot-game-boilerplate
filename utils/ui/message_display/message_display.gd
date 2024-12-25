extends Label

@onready var message_timer = $message_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProfileManager.connect("message", Callable(self, "_on_message"))
	# ConfigManager.connect("message", Callable(self, "_on_message"))
	# AudioManager.connect("message", Callable(self, "_on_message"))
	# VideoManager.connect("message", Callable(self, "_on_message"))
	# InputManager.connect("message", Callable(self, "_on_message"))
	GameManager.connect("message", Callable(self, "_on_message"))

	message_timer.connect("timeout", Callable(self, "_on_message_timer_timeout"))

func _on_message(message):
	set_text( message if get_text() == "" else get_text() + "\n" + message )
	message_timer.start()

func _on_message_timer_timeout():
	set_text("")
