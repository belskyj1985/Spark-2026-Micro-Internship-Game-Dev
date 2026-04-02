extends Node2D
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($Label, "position:y",-224.0,2.0)
	await tween.finished
	var tween2 = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_CUBIC)
	tween2.tween_property($Label2, "position:y",-024.0,2.0)
	


func _on_label_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
