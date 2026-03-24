extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sprite: Sprite2D = $AnimatedSprite2D

var side :int = 1
var action_count :int = 0
var health :int = 3000
var max_health :int = 3000
var status: String = ""

var active :bool = false

var aggressive :bool = true

func activate():
	active = true

func get_hit(dmg):
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()
	
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		queue_free()

func get_player_side() -> int: 
	return sign(global_position.x - Global.player.global_position.x)

func _on_action_timer_timeout() -> void:
	if active:
		match action_count%2:
			1:
				pass
			0:
				pass
		#if global_position.distance_squared_to(Global.player.global_position) < 400:
			#velocity = Vector2()
		action_count += 1

var target_y :int = 290
var target_pos :Vector2 = Vector2(5150,290)

var choice = randi_range(0,4)


func _ready() -> void:
	Global.boss = self

func _physics_process(delta: float) -> void:
	play_anims()
	get_player_side()
	if active:
		if !is_on_floor():
			velocity.y += 2000 * delta
		
		
		target_pos = Global.player.global_position + Vector2(0,100 * side)
		if aggressive:
			if global_position.distance_squared_to(target_pos) < 100:
				velocity.x = 500 * side
		move_and_slide()

func play_anims():
	if is_on_floor():
		if velocity.x == 0:
			animator.play("stand")
		else :
			animator.play("run")

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


func _on_switch_timer_timeout() -> void:
	aggressive = !aggressive
