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
		if Global.player != null:
			$BoxContainer/Label.text = "Health: {0}/{1} \nDamage: {2} \n ".format([Global.player.health, Global.player.max_health, int(Global.player.bullet_damage * (1.0 + 0.2 * Global.player.dmg_buff))])
	else:
		Global.paused = false
		Engine.time_scale = 1
	
	if down:
		progress_bar.value += 0.5
	else:
		progress_bar.value -= 1
	if progress_bar.ratio == 1:
		get_tree().reload_current_scene()


func _on_options_pressed() -> void:
	$options_menu.visible = !$options_menu.visible



func _on_showcursor_toggled(toggled_on: bool) -> void:
	
	Global.Options["showCursor"] = !Global.Options["showCursor"]
	print(Global.Options["showCursor"])


func _on_hold_2_fire_toggled(toggled_on: bool) -> void:
	Global.Options["hold2fire"] = !Global.Options["hold2fire"]
	print(Global.Options["hold2fire"])


func _on_back_pressed() -> void:
	$options_menu.visible = !$options_menu.visible


func _on_save_pressed() -> void:
	SaveLoad._save()


func _on_load_pressed() -> void:
	SaveLoad._load()
	Global.player.load_save_data()
	print(SaveLoad.contents_to_save["hp"])


func _on_controls_pressed() -> void:
	$BoxContainer/keys.visible = !$BoxContainer/keys.visible


func _on_music_toggled(toggled_on: bool) -> void:
	if Global.music != null:
		Global.music.stream_paused = !Global.music.stream_paused

var sfx = true
func _on_sfx_toggled(toggled_on: bool) -> void:
	sfx = !sfx
	for i in get_tree().get_nodes_in_group("SFX"):
		print(i.name)
		if $options_menu/sfx.button_pressed:
			i.volume_db = -100
		else:
			i.volume_db = 0
