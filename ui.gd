extends Control
@onready var c1: Label = $VBoxContainer/c1
@onready var c2: Label = $VBoxContainer/c2
@onready var health_bar: ProgressBar = $TextureProgressBar
@onready var hp_text: Label = $TextureProgressBar/Label

var hp_target :float = 100
func _ready() -> void:
	Global.UI = self

func _physics_process(delta: float) -> void:
	hp_target = float(Global.player.health)/Global.player.max_health * 100
	if Global.player != null:
		health_bar.value = lerp(health_bar.value, hp_target, 0.1)
		hp_text.text = str(Global.player.health) + "/" + str(Global.player.max_health)
