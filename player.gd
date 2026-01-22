extends CharacterBody2D
var input_vector : Vector2 
const GRAV :int = 2000
const SPD : int = 400
var jump_force : int = 600

var aim_angle : float = 0

var state = state_enum.move
enum state_enum {
	move,
	slide,
	aim,
}

func _ready() -> void:
	Global.player = self

func get_input_vector():
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left") 
	input_vector.y = Input.get_action_strength("up") - Input.get_action_strength("down")



func _physics_process(delta: float) -> void:
	print(state)
	match state:
		state_enum.move:
			move(delta)
		state_enum.slide:
			slide(delta)
		state_enum.aim:
			aim(delta)

	velocity.y += GRAV * delta

func move(delta):
	if Input.is_action_pressed("aim"):
		state = state_enum.aim
	get_input_vector()
	if Input.is_action_pressed("sprint"):
		velocity.x = input_vector.x * SPD * 1.4
	else:
		velocity.x = input_vector.x * SPD
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
	else:
		if velocity.y < 0 && Input.is_action_just_released("jump"):
			velocity.y /= 3
	move_and_slide()

func slide(delta):
	pass

func aim(delta):
	if !Input.is_action_pressed("aim"):
		state = state_enum.aim
	get_input_vector()
	velocity.x = input_vector.x * SPD * 0.6
	aim_angle = (global_position - get_global_mouse_position()).angle()
	move_and_slide()
