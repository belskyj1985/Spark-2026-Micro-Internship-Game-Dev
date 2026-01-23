extends CharacterBody2D
var input_vector : Vector2 
const GRAV :int = 2000
const SPD : int = 200
var jump_force : int = 600

var aim_angle : float = 0.0
var reticle_a_target : float = 0.0

var state = state_enum.move
enum state_enum {
	move,
	slide,
	aim,
}

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
	
	if sign(input_vector.x) != 0:
		sprites.flip_h = (sign(input_vector.x) == -1)
		
		if sprites.flip_h:
			sprites.offset.x = -6
		else:
			sprites.offset.x = 0
	
	if is_on_floor():
		if velocity.x == 0:
			anim.play("stand")
		elif Input.is_action_pressed("sprint"):
			anim.play("run")
		else:
			anim.play("walk")
	else:
		anim.play("jump")
func _physics_process(delta: float) -> void:
	print(state)
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
	if Input.is_action_pressed("aim"):
		reticle_a_target = 1
		state = state_enum.aim
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

func aim(delta):
	if !Input.is_action_pressed("aim"):
		reticle_a_target = 0
		state = state_enum.move
	get_input_vector()
	velocity.x = input_vector.x * SPD * 0.6
	
	reticle.global_position = get_global_mouse_position()
	aim_angle = (global_position - get_global_mouse_position()).angle()
	move_and_slide()
