class_name Health extends Sprite3D

signal zero_health

@export var health_points: float = 1:
	set(new_health_points):
		health_points = new_health_points
		update_hp_bar()
		if health_points <= 0:
			zero_health.emit()
	get:
		return health_points

@export var health_points_max: float = 1:
	set(new_health_points_max):
		health_points_max = new_health_points_max
		update_hp_bar()
	get:
		return health_points_max

@export var health_points_recovery: float = 1:
	set(new_health_points_recovery):
		health_points_recovery = new_health_points_recovery
	get:
		return health_points_recovery

@onready var health_points_color: Color:
	get:
		return Color(1.0, 0.0, 0.0).lerp(Color(0, 1, 0), health_points / health_points_max)
@onready var health_points_bar: ProgressBar = $health_viewport/health_bar

@onready var is_alive: bool:
	get:
		return health_points > 0

func _ready() -> void:
	update_hp_bar()

func _process(delta: float) -> void:
	health_points = clampf(health_points + health_points_recovery * delta, 0, health_points_max)

func set_initial_health(new_health_points: float, new_health_points_max: float, new_health_points_recovery: float) -> void:
	health_points = new_health_points
	health_points_max = new_health_points_max
	health_points_recovery = new_health_points_recovery

func update_hp_bar() -> void:
	visible = health_points != health_points_max
	if health_points_bar:
		health_points_bar.value = health_points
		health_points_bar.max_value = health_points_max
		modulate = health_points_color

func take_damage(taken_damage: float) -> void:
	health_points -= taken_damage
