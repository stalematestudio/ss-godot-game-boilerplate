extends Button

export (AudioStream) var focus_entered_audio

func _ready():
	connect("focus_entered", self, "focus_entered_effect")

func focus_entered_effect():
	focus_entered_audio.play()
