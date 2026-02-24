extends Area2D
@export var boss :Node

func _on_body_entered(body: Node2D) -> void:
	$StaticBody2D.set_collision_layer_value(1,true)
	boss.activate()
