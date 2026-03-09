extends StaticBody2D

@onready var wood_particles: CPUParticles2D = $WoodParticles
@onready var collapsing_platform: StaticBody2D = $"."
@onready var timer_before_collapse: Timer = $TimerBeforeCollapse
@onready var respawn_timer: Timer = $RespawnTimer

@export var respawning :bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if respawning == true:
			
			wood_particles.emitting = true
			wood_particles.reparent(get_parent())
			
			visible = false
			$Area2D/scanbox.set_deferred("disabled",true)
			$TileMapLayer.collision_enabled = false
			
			respawn_timer.start()
		else:
			wood_particles.emitting = true
			
			wood_particles.reparent(get_parent())
			
			collapsing_platform.queue_free()

	else:
		if body.velocity.y > 0:
			timer_before_collapse.start()
		else:
			pass

func _on_timer_before_collapse_timeout() -> void:
	if respawning == true:
		
		wood_particles.emitting = true
		wood_particles.reparent(get_parent())
		
		visible = false
		$Area2D/scanbox.set_deferred("disabled",true)
		$TileMapLayer.collision_enabled = false
		
		respawn_timer.start()

	else:
		wood_particles.emitting = true
		wood_particles.reparent(get_parent())
		collapsing_platform.queue_free()


func _on_respawn_timer_timeout() -> void:
	$TileMapLayer.collision_enabled = true
	$Area2D/scanbox.set_deferred("disabled",false)
	visible = true
