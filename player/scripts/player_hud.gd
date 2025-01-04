class_name PlayerHud extends Control

@onready var player_stats_health = $stats/health
@onready var player_stats_stamina = $stats/stamina

@onready var player_character: PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats_health.set_max(player_character.player_health_max)
	player_stats_stamina.set_max(player_character.player_stamina_max)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player_stats_health.set_value(player_character.player_health)
	player_stats_stamina.set_value(player_character.player_stamina)
