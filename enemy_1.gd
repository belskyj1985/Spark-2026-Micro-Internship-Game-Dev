extends CharacterBody2D
const BulletScene = preload("res://enemy_1_bullet.tscn")
@onready var range: Area2D = $range
@onready var timer: Timer = $Timer
@onready var barrel: Sprite2D = $Enemy1Barrel

var active :bool = false
var health :int = 100
var status: String = ""


func _physics_process(delta: float) -> void:
	pass

func _on_range_body_entered(body: Node2D) -> void:
	active = true
	timer.start()

func _on_range_body_exited(body: Node2D) -> void:
	timer.stop()
	active = false

var tween 

func _ready() -> void:
	tween = get_tree().create_tween()

func get_hit(dmg):
	health -= dmg
	if health <= 0:
		SaveLoad.get_c1(5)
		queue_free()
	#modulate = Color(1,.4,.4)
	if status == "":
		$HitFlash.start()

func _on_timer_timeout() -> void:
	tween.set_ease(Tween.EASE_OUT)
	var bullet_instance: Bullet = BulletScene.instantiate()
	if status == "lightning":
		bullet_instance.damage /= 2
	
	get_tree().current_scene.add_child(bullet_instance)
	var v = 600
	var g = bullet_instance.grav
	var h = 2*(v*v)/(2*g) + (Global.player.global_position - global_position).y + v/sqrt(2)
	var x_vel = (
		(Global.player.global_position - global_position).x/(sqrt((2*h)/g))
	)
	
	bullet_instance.setup(Vector2(x_vel,-v), 30)
	#bullet_instance.setup(Global.player.global_position-global_position, 30)
	bullet_instance.body_entered.connect(bullet_instance._on_body_entered)
	bullet_instance.global_position = global_position
	
	tween.tween_property(barrel, "rotation",  Vector2(x_vel,-v).angle() + PI/2, 0.5)

	barrel.rotation = Vector2(x_vel,-v).angle() + PI/2

func apply_status(type):
	status = type
	$StatusEffect.start()
	$Tick.start()
	if type == "ice":
		print("ICE")
		$Timer.wait_time = 2.0
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if type == "lightning":
		print("LIGHTNING")
		
		modulate = Color(1.0, 0.933, 0.0, 1.0)

func _on_HitFlash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)


func _on_status_effect_timeout() -> void:
	print("modulate done")
	status = ""
	modulate = Color(1,1,1)
	$Tick.stop()
	$Timer.wait_time = 1.0


func _on_tick_timeout() -> void:
	get_hit(2)
