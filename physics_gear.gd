extends RigidBody2D

@export var respawning :bool = false
@onready var respawn_timer: Timer = $RespawnTimer

var starting_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	if respawning:
		starting_position = global_position
		respawn_timer.start()

func _on_hitbox_body_entered(body: Node2D) -> void:
	Global.player.get_hit(global_position, 50, 400)


func _on_respawn_timer_timeout() -> void:
	global_position = starting_position
