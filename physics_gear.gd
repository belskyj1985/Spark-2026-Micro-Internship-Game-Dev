extends RigidBody2D

@export var respawning :bool = false
@onready var respawn_timer: Timer = $RespawnTimer
@onready var spawn_timer: Timer = $SpawnTimer

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	spawn_timer.start()
	freeze = true


func _on_hitbox_body_entered(body: Node2D) -> void:
	Global.player.get_hit(50)


func _on_spawn_timer_timeout() -> void:
	if respawning:
		starting_position = global_position
		respawn_timer.start()
		freeze = false
	else:
		freeze = false

func _on_respawn_timer_timeout() -> void:
	global_position = starting_position
