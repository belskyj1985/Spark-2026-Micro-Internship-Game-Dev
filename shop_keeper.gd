extends Node2D

@onready var v_box_container: VBoxContainer = $UI/VBoxContainer
@onready var ui: Control = $UI
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeperSprite

# --- UI ---
var detected: bool = false

# --- Pacing ---
@export var pace_distance: float = 80.0
@export var max_speed: float = 40.0
@export var lean_amount: float = 0.08  # radians (~5 degrees)
@export var acceleration: float = 4.0  # how fast he speeds up / slows down

var start_x: float
var direction: int = 1
var current_speed: float = 0.0

func _ready() -> void:
	v_box_container.visible = false
	start_x = global_position.x


func _physics_process(delta: float) -> void:
	
	# --- UI Slide ---
	if detected:
		v_box_container.position.y = lerpf(v_box_container.position.y, -150, .08)
	else:
		v_box_container.position.y = lerpf(v_box_container.position.y, -1000, .01)
	
	# --- Handle Speed ---
	if detected:
		# Smoothly slow to stop
		current_speed = lerpf(current_speed, 0.0, acceleration * delta)
	else:
		# Smoothly accelerate to max speed
		current_speed = lerpf(current_speed, max_speed, acceleration * delta)
	
	# --- Movement ---
	global_position.x += direction * current_speed * delta
	
	# Check bounds (only change direction if moving)
	if not detected:
		if global_position.x > start_x + pace_distance:
			direction = -1
		elif global_position.x < start_x - pace_distance:
			direction = 1
	
	# Flip sprite
	shop_keeper_sprite.flip_h = direction < 0
	
	# Lean based on movement speed (leans less when stopping)
	var target_lean = lean_amount * direction * (current_speed / max_speed)
	
	shop_keeper_sprite.rotation = lerpf(
		shop_keeper_sprite.rotation,
		target_lean,
		6 * delta
	)


func _on_area_2d_body_entered(body: Node2D) -> void:
	v_box_container.visible = true
	detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	detected = false


func _on_button_1_pressed() -> void:
	if SaveLoad.contents_to_save["c1"] >= 10:
		SaveLoad.get_c1(-10)
		print("you lost 10 bucks")
