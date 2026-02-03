extends RigidBody2D


func _on_hitbox_body_entered(body: Node2D) -> void:
	Global.player.get_hit(global_position, 50, 400)
