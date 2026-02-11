extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer

var side :int = 1
var jump_dir :int = -1
var action_count :int = 0
func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	print("timeout")
	match action_count%2:
		1:
			spawn()
		0:
			jump()
	#if global_position.distance_squared_to(Global.player.global_position) < 400:
		#velocity = Vector2()
	action_count += 1

func jump() -> void:
	animator.play("crouch")
	await get_tree().create_timer(0.3).timeout
	global_position = choose_local()
	velocity.y = -100
	animator.play("jump")
	
var choice = randi_range(0,4)
func choose_local():
	var init = choice
	while choice == init:
		choice = randi_range(0,4)
	side *= -1
	print(choice)
	match choice:
		0:
			return Vector2(5150,290)
		1:
			return Vector2(5860,290)
		2:
			return Vector2(5150,450)
		3:
			return Vector2(5860,450)
		4:
			return Vector2(5510,360)
	
func spawn() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += 200 * delta
	if is_on_floor():
		velocity.x = 0
		animator.play("stand")
	else:
		animator.play("jump")
	move_and_slide()
