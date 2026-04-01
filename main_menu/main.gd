extends Node2D
@onready var start: TextureButton = $main/Start
var select_color :Color = Color(0.0, 0.947, 0.539, 1.0)

func _ready() -> void:
	start.grab_focus()


#func _on_start_focus_entered() -> void:
	#$main/Start/Label.label_settings.font_color = select_color
#func _on_start_focus_exited() -> void:
	#$main/Start/Label.label_settings.font_color = Color.WHITE
#
#func _on_options_focus_entered() -> void:
	#$main/Options/Label.label_settings.font_color = select_color
#func _on_options_focus_exited() -> void:
	#$main/Options/Label.label_settings.font_color = Color.WHITE
#
#func _on_credits_focus_entered() -> void:
	#$main/Credits/Label.label_settings.font_color = select_color
#func _on_credits_focus_exited() -> void:
	#$main/Credits/Label.label_settings.font_color = Color.WHITE
#
#func _on_quit_focus_entered() -> void:
	#$main/Quit/Label.label_settings.font_color = select_color
#func _on_quit_focus_exited() -> void:
	#$main/Quit/Label.label_settings.font_color = Color.WHITE


func _on_options_pressed() -> void:
	#$options_menu.grab_focus()
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position:y", 972, 2.0)
	


func _on_showcursor_toggled(toggled_on: bool) -> void:
	Global.Options["showCursor"] = !Global.Options["showCursor"]


func _on_hold_2_fire_toggled(toggled_on: bool) -> void:
	Global.Options["hold2fire"] = !Global.Options["hold2fire"]


func _on_back_pressed() -> void:
	$main/Options.grab_focus()
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position:y", 324, 2.0)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_credits_pressed() -> void:
	$credits_menu/return.grab_focus()
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position:x", 1729.0, 2.0)


func _on_return_pressed() -> void:
	$credits_menu/return.grab_focus()
	var tween = get_tree().create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Camera2D, "position:x", 576.0, 2.0)
