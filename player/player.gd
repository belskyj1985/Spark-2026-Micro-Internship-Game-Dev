extends CharacterBody2D

var health :int = 100
var max_health :int = 100
var defense :float = 0

var input_vector : Vector2 
const GRAV :int = 2000
const SPD : int = 200
var jump_force : int = 650
var djs :int = 1
var dashes :int = 1

var aim_angle : float = 0.0
var reticle_a_target : float = 0.0


var stunned :bool = false
var bullet_offset = Vector2(28, -16)
var can_shoot :bool = true
const NormalBulletScene = preload("res://player/player_bullet.tscn")
const FireBulletScene = preload("res://player/player_fire_bullet.tscn")
const IceBulletScene = preload("res://player/player_ice_bullet.tscn")
const LightningBulletScene = preload("res://player/player_lightning_bullet.tscn")
var BulletScene = NormalBulletScene

var bullet_speed :int = 400
var bullet_gravity :int = 20
var bullet_lifetime :float = 2.0
var bullet_damage :int = 20
var dmg_buff :float = 0.0

var vulnerable :bool = true

var state = state_enum.move
enum state_enum {
	move,
	slide,
	aim,
}
@onready var melee_attack: Area2D = $melee_attack
@onready var stun: Timer = $stun
@onready var inv_timer: Timer = $invincibility
@onready var dash_timer: Timer = $dash
@onready var melee_timer: Timer = $melee
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprites: Sprite2D = $AnimatedSprite2D
@onready var reticle: Sprite2D = $Reticle

@onready var player_shoot: AudioStreamPlayer = $PlayerShoot
@onready var jumpSound: AudioStreamPlayer = $Jump
@onready var step: AudioStreamPlayer = $Step
@onready var player_dmg: AudioStreamPlayer = $PlayerDmg


func _ready() -> void:
	Global.player = self
	Global.enemy_die = $EnemyDie
	

func load_save_data():
	if SaveLoad.contents_to_save["fire"] == 2:
		Global.player.switch_bullet("fire")
	if SaveLoad.contents_to_save["lightning"] == 2:
		Global.player.switch_bullet("lightning")
	if SaveLoad.contents_to_save["ice"] == 2:
		Global.player.switch_bullet("ice")
	
	max_health = 100 + (SaveLoad.contents_to_save["hp"]) * 20
	health = SaveLoad.contents_to_save["cur_hp"]
	
	defense = SaveLoad.contents_to_save["def"]
	dmg_buff = SaveLoad.contents_to_save["dmg"]
func get_input_vector():
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	input_vector.y = Input.get_action_strength("up") - Input.get_action_strength("down")

func jump():
	jumpSound.play()
	if sign(get_floor_normal().x) != sign(velocity.x) && get_floor_normal().x != 0:
		velocity.y = -jump_force * 1.1
	else:
		velocity.y = -jump_force

func do_anims():
	reticle.modulate.a = lerp(reticle.modulate.a, reticle_a_target, 0.1)
	sprites.scale = lerp(sprites.scale, Vector2(1,1), 0.15)
	if Input.is_action_just_pressed("jump") && !is_on_floor():
		sprites.scale = Vector2(1, 0.6)
	
	if state == state_enum.move:
		if sign(input_vector.x) != 0:
			sprites.flip_h = (sign(input_vector.x) == -1)
	elif state == state_enum.aim:
		sprites.flip_h = (sign(global_position.x - get_global_mouse_position().x) == 1)
	
	if sprites.flip_h:
		bullet_offset = Vector2(-37, -16)
		sprites.offset.x = -6
	else:
		bullet_offset = Vector2(37, -16)
		sprites.offset.x = 0
	
		
	if is_on_floor():
		if velocity.x == 0:
			anim.play("stand")
		elif Input.is_action_pressed("sprint") && state != state_enum.aim:
			anim.play("run")
			
		else:
			anim.play("walk")
	else:
		anim.play("jump")
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		SaveLoad.get_c1(1200)
	
	
	vulnerable = inv_timer.is_stopped()
	
	match state:
		state_enum.move:
			move(delta)
		state_enum.slide:
			slide(delta)
		state_enum.aim:
			aim(delta)
	
	do_anims()
	velocity.y += GRAV * delta

func move(delta):
	if sprites.flip_h:
		melee_attack.position.x = -64
	else:
		melee_attack.position.x = 0
	
	if SaveLoad.contents_to_save["melee"] == 2 && melee_timer.is_stopped() && Input.is_action_just_pressed("melee"):
		$melee_attack.monitoring = true
		melee_attack.visible = true
		await get_tree().create_timer(0.1).timeout
		$melee_attack.monitoring = false
		melee_attack.visible = false
	
	if SaveLoad.contents_to_save["dash"] == 2 && dashes > 0 && dash_timer.is_stopped() && Input.is_action_just_pressed("dash"):
		if sprites.flip_h:
			velocity.x = -1000
		else:
			velocity.x = 1000
		velocity.y = 0
		dashes -= 1
	if Global.Options["hold2fire"]:
		if Input.is_action_pressed("shoot") && can_shoot && !Global.paused:
			shoot()
	else:
		if Input.is_action_just_pressed("shoot") && can_shoot && !Global.paused:
			shoot()
	if Input.is_action_pressed("aim"):
		if Global.Options["showCursor"]:
			reticle_a_target = 1
		state = state_enum.aim
	
	#if !stunned:
	get_input_vector()
	if input_vector.x != 0:
		if Input.is_action_pressed("sprint"):
			velocity.x = move_toward(velocity.x, input_vector.x * SPD * 1.8, 3000 * delta)
		else:
			velocity.x = move_toward(velocity.x, input_vector.x * SPD, 3000 * delta)
	else:
		if !vulnerable:
			velocity.x = move_toward(velocity.x, input_vector.x * SPD, 2000 * delta)
		else:
			velocity.x = move_toward(velocity.x, input_vector.x * SPD, 3000 * delta)
	if is_on_floor():
		djs = 1
		dashes = 1
		if Input.is_action_just_pressed("jump"):
			jump()
	else:
		if Input.is_action_just_pressed("jump") && SaveLoad.contents_to_save["dj"] == 2 && djs > 0:
			jump()
			djs -= 1
		if velocity.y < 0 && Input.is_action_just_released("jump"):
			velocity.y /= 3
	move_and_slide()

func slide(delta):
	pass

func shoot():
	var bullet_instance: Bullet = BulletScene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	
	if state == state_enum.aim:
		bullet_instance.setup(get_global_mouse_position() - (global_position + bullet_offset), int(bullet_damage * (1.0 + 0.2 * dmg_buff)) )
		bullet_instance.sprite.rotation = (get_global_mouse_position() - (global_position + bullet_offset)).angle() 
	elif state == state_enum.move:
		bullet_instance.setup(Vector2(bullet_speed * sign(bullet_offset.x), 0), int(bullet_damage * (1.0 + 0.2 * dmg_buff)) )
		#flip bullet
		bullet_instance.sprite.scale.x = sign(bullet_offset.x)
	bullet_instance.body_entered.connect(bullet_instance._on_body_entered)
	bullet_instance.global_position = global_position + bullet_offset
	bullet_instance.speed = bullet_speed
	bullet_instance.damage = int(bullet_damage * (1.0 + 0.2 * dmg_buff))
	bullet_instance.lifetime = bullet_lifetime
	
	player_shoot.pitch_scale = 1 + randf_range(-0.1,0.1)
	player_shoot.play()
	
	can_shoot = false
	await get_tree().create_timer(0.1).timeout
	can_shoot = true
	
func switch_bullet(type :String):
	match type:
		"fire":
			BulletScene = FireBulletScene
		"ice":
			BulletScene = IceBulletScene
		"lightning":
			BulletScene = LightningBulletScene
		"":
			BulletScene = NormalBulletScene

func aim(delta):
	if Global.Options["hold2fire"]:
		if Input.is_action_pressed("shoot") && can_shoot && !Global.paused:
			shoot()
	else:
		if Input.is_action_just_pressed("shoot") && can_shoot && !Global.paused:
			shoot()
	if !Input.is_action_pressed("aim"):
		reticle_a_target = 0
		state = state_enum.move
	get_input_vector()
	velocity.x = input_vector.x * SPD * 0.6
	
	reticle.global_position = get_global_mouse_position()
	aim_angle = (global_position - get_global_mouse_position()).angle()
	move_and_slide()

func get_hit(dmg):
	if vulnerable:
		player_dmg.play()
		health = clamp(health - dmg * ( 1.0/((defense+2.0)*0.5) ), 0, max_health)
		inv_timer.start()
		tranq(0.5)
		velocity.y = -500
		if sprites.flip_h:
			velocity.x = 300
		else:
			velocity.x = -300
		
		SaveLoad.contents_to_save["cur_hp"] = health

func tranq(time :float):
	stunned = true
	stun.start(time)



func _on_stun_timeout() -> void:
	stunned = false


func _on_melee_attack_body_entered(body: Node2D) -> void:
	body.get_hit(bullet_damage*2)


func _on_animated_sprite_2d_frame_changed() -> void:
	if sprites.frame == 2 || sprites.frame == 4 || sprites.frame == 8 || sprites.frame == 11: 
		step.pitch_scale = 1 + randf_range(-0.1,0.1)
		step.play()
