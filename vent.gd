extends Area2D

var targets = []

func _on_body_entered(body: Node2D) -> void:
	targets.append(body)

func _on_body_exited(body: Node2D) -> void:
	targets.pop_at(targets.find(body))

func _physics_process(delta: float) -> void:
	for i in targets:
		if i is RigidBody2D:
			i.apply_central_force(Vector2(0,-2000))
		else:
			i.velocity -= Vector2(0,2400).rotated(rotation) * delta
#2000 makes you hover btw
