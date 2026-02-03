extends Area2D

@export var scene :String = "res://game.tscn"
func _on_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file(scene)
