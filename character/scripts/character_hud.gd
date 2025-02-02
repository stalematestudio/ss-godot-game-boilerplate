class_name CharacterHud extends Control

@onready var stats_health: ProgressBar = $stats/health
@onready var stats_stamina: ProgressBar = $stats/stamina

@onready var action_pri: Label = $action/pri
@onready var action_sec: Label = $action/sec

@onready var croshair: TextureRect = $croshair

@onready var character: Character = get_parent()
@onready var character_ray_cast_3D: CharacterRayCast3D =  get_node("../character_head/character_ray_cast_3D")

func _ready() -> void:
	await character.ready
	stats_health.set_max(character.health_max)
	stats_stamina.set_max(character.stamina_max)
	character_ray_cast_3D.target_changed.connect(_on_raycast_target_changed)

func _process(_delta: float) -> void:
	if character.is_player_controlled:
		show()
		stats_health.set_value(character.health)
		stats_stamina.set_value(character.stamina)
	else:
		hide()

func _on_raycast_target_changed(raycast_target: Node) -> void:
	if raycast_target and ("interactive" in raycast_target) and (raycast_target.interactive):
		croshair.modulate = Color.GREEN
		action_pri.text = raycast_target.primary_action
		action_sec.text = raycast_target.secondary_action
	else:
		croshair.modulate = Color.WHITE
		action_pri.text = ""
		action_sec.text = ""
