extends CharacterBody2D
var jump_dir :int = -1
var action_count :int = 0
func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	
	match action_count%2:
		1:
			spawn()
		0:
			jump()
	if global_position.distance_squared_to(Global.player.global_position) < 400:
		velocity = Vector2()
	action_count += 1

func jump() -> void:
	pass

func spawn() -> void:
	pass
