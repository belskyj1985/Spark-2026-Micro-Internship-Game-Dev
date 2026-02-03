extends CharacterBody2D

var health :int = 100
var max_health :int = 100

var input_vector : Vector2 
const GRAV :int = 2000
const SPD : int = 200
var jump_force : int = 600

var aim_angle : float = 0.0
var reticle_a_target : float = 0.0


var stunned :bool = false
var bullet_offset = Vector2(28, -16)
var can_shoot :bool = true
const BulletScene = preload("res://player_bullet.tscn")

var bullet_speed :int = 400
var bullet_gravity :int = 20
var bullet_lifetime :float = 2.0
var bullet_damage :int = 10

var vulnerable :bool = true

var state = state_enum.move
enum state_enum {
	move,
	slide,
	aim,
}
@onready var stun: Timer = $stun
@onready var inv_timer: Timer = $invincibility
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprites: Sprite2D = $AnimatedSprite2D
@onready var reticle: Sprite2D = $Reticle

func _ready() -> void:
	Global.player = self

func get_input_vector():
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	input_vector.y = Input.get_action_strength("up") - Input.get_action_strength("down")

func jump():
	if sign(get_floor_normal().x) != sign(velocity.x) && get_floor_normal().x != 0:
		velocity.y = -jump_force * 1.4
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
		bullet_offset = Vector2(-28, -16)
		sprites.offset.x = -6
	else:
		bullet_offset = Vector2(28, -16)
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
	print(health)
	
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
	shoot()
	if Input.is_action_pressed("aim"):
		reticle_a_target = 1
		state = state_enum.aim
	
	if !stunned:
		get_input_vector()
		if Input.is_action_pressed("sprint"):
			velocity.x = input_vector.x * SPD * 1.8
		else:
			velocity.x = input_vector.x * SPD
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			jump()
	else:
		if velocity.y < 0 && Input.is_action_just_released("jump"):
			velocity.y /= 3
	move_and_slide()

func slide(delta):
	pass

func shoot():
	if Input.is_action_just_pressed("shoot") && can_shoot && !Global.paused:
		var bullet_instance: Bullet = BulletScene.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		if state == state_enum.aim:
			bullet_instance.setup(get_global_mouse_position() - global_position + bullet_offset, bullet_damage)
		elif state == state_enum.move:
			bullet_instance.setup(Vector2(bullet_speed * sign(bullet_offset.x), 0), bullet_damage)
		bullet_instance.body_entered.connect(bullet_instance._on_body_entered)
		bullet_instance.global_position = global_position + bullet_offset
		bullet_instance.speed = bullet_speed
		bullet_instance.damage = bullet_damage
		bullet_instance.lifetime = bullet_lifetime
		
		can_shoot = false
		await get_tree().create_timer(0.1).timeout
		can_shoot = true

func aim(delta):
	shoot()
	if !Input.is_action_pressed("aim"):
		reticle_a_target = 0
		state = state_enum.move
	get_input_vector()
	velocity.x = input_vector.x * SPD * 0.6
	
	reticle.global_position = get_global_mouse_position()
	aim_angle = (global_position - get_global_mouse_position()).angle()
	move_and_slide()
func get_hit(pos, dmg :int = 20, kb :int = 200):
	if vulnerable:
		health = clamp(health - dmg, 0, max_health)
		inv_timer.start()
		tranq(0.5)
		velocity.y = -500
		velocity.x = sign((global_position - pos).x) * kb

func tranq(time :float):
	stunned = true
	stun.start(time)



func _on_stun_timeout() -> void:
	stunned = false
