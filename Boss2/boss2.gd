extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: Sprite2D = $AnimatedSprite2D

var side :int = 1
var action_count :int = 0
var health :int = 3000
var max_health :int = 3000
var status: String = ""
const acc :int = 1000
var active :bool = false
var bullet_offset = Vector2.ZERO
var aggressive :bool = true
var bullet_damage :int = 10
const bullet = preload("res://Boss2/evil_player_bullet.tscn")

func activate():
	active = true

func get_hit(dmg):
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()
	$EnemyDmg.play()
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		Global.enemy_die.play()
		queue_free()

func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	if active:
		match action_count%2:
			1:
				action(1)
			0:
				action(2)
		#if global_position.distance_squared_to(Global.player.global_position) < 400:
			#velocity = Vector2()
		action_count += 1

var target_y :int = 290
var target_pos :Vector2 = Vector2(5150,290)

var choice = randi_range(0,4)

func shoot_angle():
	for i in range(3):
		var bullet_instance: Bullet = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.setup(Global.player.global_position - (global_position + bullet_offset), bullet_damage)
		bullet_instance.sprite.rotation = (Global.player.global_position - global_position - bullet_offset).angle() 
		bullet_instance.global_position = global_position + bullet_offset
		bullet_instance.speed = 400
		await get_tree().create_timer(0.08).timeout

func shoot_shotgun():
	var angle_offset :float = PI/6
	for i in range(3):
		var bullet_instance: Bullet = bullet.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.setup(Vector2(sign(bullet_offset.x), 0).rotated(angle_offset), bullet_damage)
		bullet_instance.sprite.rotation = Vector2(sign(bullet_offset.x), 0).angle() + angle_offset
		bullet_instance.global_position = global_position + bullet_offset
		bullet_instance.speed = 400
		angle_offset -= PI/6
	await get_tree().create_timer(0.08).timeout


func action(type :int = 1):
	match type:
		1:
			if aggressive:
				shoot_angle()
			else:
				shoot_angle()
		2:
			if aggressive:
				
				shoot_shotgun()
			else:
				shoot_shotgun()

func _ready() -> void:
	Global.boss = self

func _physics_process(delta: float) -> void:
	play_anims() 
	print(Global.player.global_position.y < global_position.y - 100)
	side = get_player_side()
	if active:
		if !is_on_floor():
			velocity.y += 2000 * delta
		
		if aggressive:
			if is_on_wall():
				jump()
			
			if (Global.player.global_position.y < global_position.y - 100) && (Global.player.global_position.x - global_position.x < 100) && is_on_floor():
					jump()
			
			if Global.player != null:
				target_pos = Global.player.global_position + Vector2(50,0)
			
			if global_position.distance_squared_to(target_pos) < 200:
				velocity.x = move_toward(velocity.x, 0, acc * delta)
			else:
				velocity.x = move_toward(velocity.x, -sign(global_position.x - target_pos.x) * 200, acc * delta)
		else:
			if Global.player != null:
				target_pos = Global.player.global_position + Vector2(200,0)
			
			if global_position.distance_squared_to(target_pos) < 200:
				velocity.x = move_toward(velocity.x, 0, acc * delta)
			else:
				velocity.x = move_toward(velocity.x, -sign(global_position.x - target_pos.x) * 200, acc * delta)
	move_and_slide()

func jump():
	animator.play("jump")
	velocity.y = -800

func play_anims():
	if sign(velocity.x) != 0:
		sprite.flip_h = sign(velocity.x) == -1
	else:
		sprite.flip_h = (sign(get_player_side()) == 1)
	if sprite.flip_h:
		bullet_offset = Vector2(-37, -16)
		sprite.offset.x = -6
	else:
		bullet_offset = Vector2(37, -16)
		sprite.offset.x = 0
	if is_on_floor():
		if velocity.x == 0:
			animator.play("stand")
		else:
			animator.play("run")

func apply_status(type):
	status = type
	$StatusEffect.start()
	
	if type == "ice":
		$action_Timer.wait_time *= 2.0
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
	$action_Timer.wait_time /= 2.0

func _on_tick_timeout() -> void:
	get_hit(2)


func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)


func _on_switch_timer_timeout() -> void:
	aggressive = !aggressive
