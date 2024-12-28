extends Timer

@onready var time_increment = get_wait_time()

func _ready():
	timeout.connect(increment_game_play_time)

func increment_game_play_time():
	ProfileManager.game_play_time = ProfileManager.game_play_time + time_increment
	ProfileManager.save_profile()
