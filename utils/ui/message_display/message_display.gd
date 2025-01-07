extends Label

@onready var message_timer = $message_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProfileManager.message.connect(_on_message)
	# ConfigManager.message.connect(_on_message)
	# AudioManager.message.connect(_on_message)
	# VideoManager.message.connect(_on_message)
	# InputManager.message.connect(_on_message)
	GameManager.message.connect(_on_message)

	message_timer.timeout.connect(_on_message_timer_timeout)

func _on_message(message):
	set_text( message if get_text() == "" else get_text() + "\n" + message )
	message_timer.start()

func _on_message_timer_timeout():
	set_text("")
