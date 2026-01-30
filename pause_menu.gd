extends Control
var down :bool = false
@onready var progress_bar: ProgressBar = $BoxContainer/recall/ProgressBar

func _on_recall_button_down() -> void:
	down = true

func _on_recall_button_up() -> void:
	down = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		print("PRESSED IT")
		visible = !visible
	if visible:
		Global.paused = true
		Engine.time_scale = 0
		
		$BoxContainer/Label.text = "Health: {0}/{1} \nDamage: {2} \n ".format([Global.player.health, Global.player.max_health, Global.player.bullet_damage])
	else:
		Global.paused = false
		Engine.time_scale = 1
	
	if down:
		progress_bar.value += 0.5
	else:
		progress_bar.value -= 1
	if progress_bar.ratio == 1:
		get_tree().reload_current_scene()
