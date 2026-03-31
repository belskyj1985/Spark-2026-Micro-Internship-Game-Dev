extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: Sprite2D = $AnimatedSprite2D

var side :int = 1
var jump_dir :int = -1
var action_count :int = 0
var shaking :bool = false

var health :int = 2400
var max_health :int = 2400
var fly_total :int = 0
var status: String = ""

var pos_offset
var fly = preload("res://boss1/fly.tscn")

var active :bool = false

func activate():
	active = true

func get_hit(dmg):
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()
	
	print(float(health)/max_health)
	$EnemyDmg.play()
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		SaveLoad.get_c1(50)
		Global.enemy_die.play()
		$"../door".rise()
		queue_free()

func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	if active:
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
	
	var offset :Vector2 = Vector2.ZERO
	for i in randi_range(3,5):
		if fly_total < 10:
			var fly_inst: CharacterBody2D = fly.instantiate()
			fly_total += 1
			get_tree().current_scene.add_child(fly_inst)
			fly_inst.global_position = global_position + offset
			offset += Vector2(0,-30)
			fly_inst.animated_sprite_2d.play("idle")
		await get_tree().create_timer(0.1).timeout
	
	animator.play("crouch")
	print("timer start")
	shaking = true
	await get_tree().create_timer(0.3).timeout
	shaking = false
	print("timer end")
	animator.play("jump")
	target_y = 200

func _ready() -> void:
	Global.boss = self
	pos_offset = global_position

func _physics_process(delta: float) -> void:
	#velocity.y += 200 * delta
	if shaking:
		sprite.position.x = randi_range(-8,8)
		print(sprite.position.x)
	else:
		sprite.position.x = 0
	
	if active:
		position.y = move_toward(position.y,target_y,1000 * delta)
		if position.y == target_y && !animator.current_animation == "crouch":
			animator.play("stand")
		move_and_slide()

func apply_status(type):
	status = type
	$StatusEffect.start()
	
	if type == "ice":
		$action_Timer.wait_time = 2.0
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if type == "lightning":
		modulate = Color(1.0, 0.933, 0.0, 1.0)
	if type == "fire":
		$Tick.start()
		modulate = Color(1.0, 0.0, 0.0, 1.0)

func _on_status_effect_timeout() -> void:
	status = ""
	modulate = Color(1,1,1)
	$Tick.stop()
	$action_Timer.wait_time = 1.0

func _on_tick_timeout() -> void:
	get_hit(2)


func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)
