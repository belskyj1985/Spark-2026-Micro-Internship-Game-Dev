extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $ProgressBar

var side :int = 1
var jump_dir :int = -1
var action_count :int = 0

var health :int = 2400
var max_health :int = 2400

var pos_offset
var fly = preload("res://boss1/fly.tscn")

func get_hit(dmg):
	print(float(health)/max_health)
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		queue_free()

func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	match action_count%2:
		1:
			spawn()
		0:
			jump()
	#if global_position.distance_squared_to(Global.player.global_position) < 400:
		#velocity = Vector2()
	action_count += 1

var target_y :int = 290
var target_pos :Vector2 = Vector2(5150,290)
func jump() -> void:
	animator.play("crouch")
	await get_tree().create_timer(0.3).timeout
	target_pos = choose_local() + pos_offset
	global_position.x = target_pos.x
	target_y = target_pos.y
	#velocity.y = -100
	animator.play("jump")
	
var choice = randi_range(0,4)
func choose_local():
	var init = choice
	while choice == init:
		choice = randi_range(0,4)
	side *= -1
	match choice:
		0:
			return Vector2(5150,290) - Vector2(5157,311)
		1:
			return Vector2(5860,290) - Vector2(5157,311)
		2:
			return Vector2(5150,450) - Vector2(5157,311)
		3:
			return Vector2(5860,450) - Vector2(5157,311)
		4:
			return Vector2(5510,360) - Vector2(5157,311)
	
func spawn() -> void:
	
	print("spawned?")
	var offset :Vector2 = Vector2.ZERO
	for i in randi_range(3,5):
		var fly_inst: CharacterBody2D = fly.instantiate()
		get_tree().current_scene.add_child(fly_inst)
		fly_inst.global_position = global_position + offset
		offset += Vector2(0,-30)
		fly_inst.animated_sprite_2d.play("idle")
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(0.1).timeout
	target_y = -1000

func _ready() -> void:
	pos_offset = global_position

func _physics_process(delta: float) -> void:
	#velocity.y += 200 * delta
	position.y = move_toward(position.y,target_y,1000 * delta)
	if is_on_floor():
		velocity.x = 0
		if animator.current_animation != "crouch":
			animator.play("stand")
	else:
		animator.play("jump")
	move_and_slide()
