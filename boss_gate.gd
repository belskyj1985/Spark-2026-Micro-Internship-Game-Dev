extends Area2D
@export var boss :Node

func _on_body_entered(body: Node2D) -> void:
	$StaticBody2D.set_collision_layer_value(1,true)
	boss.activate()
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property($BossGate, "position:y",44.0,1.0)
