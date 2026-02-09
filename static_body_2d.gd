extends StaticBody2D

@onready var wood_particles: CPUParticles2D = $WoodParticles
@onready var collapsing_platform: StaticBody2D = $"."
@onready var timer_before_collapse: Timer = $TimerBeforeCollapse

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		wood_particles.emitting = true
		
		wood_particles.reparent(get_parent())
		
		collapsing_platform.queue_free()

	else:
		timer_before_collapse.start()


func _on_timer_before_collapse_timeout() -> void:
	wood_particles.emitting = true
	
	wood_particles.reparent(get_parent())
	
	collapsing_platform.queue_free()
