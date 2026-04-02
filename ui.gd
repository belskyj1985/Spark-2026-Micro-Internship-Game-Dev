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

func die():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	#tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Panel2, "modulate:a",1.0,1.0)
	await tween.finished
	SaveLoad._save()
	get_tree().change_scene_to_file("res://game.tscn")
