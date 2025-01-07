class_name PlayerHud extends Control

@onready var player_stats_health: ProgressBar = $stats/health
@onready var player_stats_stamina: ProgressBar = $stats/stamina

@onready var player_action_pri: Label = $action/pri
@onready var player_action_sec: Label = $action/sec

@onready var player_character: PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_stats_health.set_max(player_character.player_health_max)
	player_stats_stamina.set_max(player_character.player_stamina_max)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	player_stats_health.set_value(player_character.player_health)
	player_stats_stamina.set_value(player_character.player_stamina)

func _on_raycast_target_changed(raycast_target: Node) -> void:
	if raycast_target and ("interactive" in raycast_target) and (raycast_target.interactive):
		player_action_pri.text = raycast_target.primary_action
		player_action_sec.text = raycast_target.secondary_action
	else:
		player_action_pri.text = ""
		player_action_sec.text = ""
