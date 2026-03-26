extends CharacterBody2D
var active :bool = false
var health :int = 400
var status: String = ""

var raycasts :Array
const bulletscene = preload("res://enemy3/enemy3_bullet.tscn")
var detected :bool = false
var can_shoot :bool = true
var start_pos :Vector2
var accum :float = 0
@onready var shoot_timer: Timer = $shoot


@onready var u: RayCast2D = $raycasts/U
@onready var r: RayCast2D = $raycasts/R
@onready var d: RayCast2D = $raycasts/D
@onready var l: RayCast2D = $raycasts/L
@onready var ul: RayCast2D = $raycasts/UL
@onready var ur: RayCast2D = $raycasts/UR
@onready var dr: RayCast2D = $raycasts/DR
@onready var dl: RayCast2D = $raycasts/DL


func _ready() -> void:
	raycasts = $raycasts.get_children()
	start_pos = global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.player.get_hit(10)

func _physics_process(delta: float) -> void:
	accum += delta
	global_position.y += sin(accum * 2)
	print(detected)
	detected = false
	for i in raycasts:
		if i.is_colliding():
			detected = true
	if detected && can_shoot:
		attack()
		can_shoot = false

func get_hit(dmg):
	$EnemyDmg.play()
	print(dmg)
	health -= dmg
	if health <= 0:
		SaveLoad.get_c1(5)
		Global.enemy_die.play()
		queue_free()
	
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()


func apply_status(type):
	status = type
	$StatusEffect.start()
	$Tick.start()
	if type == "ice":
		$Timer.wait_time = 2.0
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if type == "lightning":
		
		modulate = Color(1.0, 0.933, 0.0, 1.0)
	if type == "fire":
		$Timer.wait_time = 2.0
		modulate = Color(1.0, 0.0, 0.0, 1.0)

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


func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)

func shoot(vec :Vector2 = Vector2.UP):
	var bullet_instance: Bullet = bulletscene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.setup(vec, 20)
	bullet_instance.rotation = vec.angle() +PI/2
	bullet_instance.global_position = global_position
	bullet_instance.speed = 400
	print(bullet_instance.damage)

func attack():
	if u.is_colliding():
		shoot(Vector2.UP)
	if ur.is_colliding():
		shoot(Vector2(-1,1))
	if ul.is_colliding():
		shoot(Vector2(-1,-1))
	if d.is_colliding():
		shoot(Vector2.DOWN)
	if dr.is_colliding():
		shoot(Vector2(1,1))
	if dl.is_colliding():
		shoot(Vector2(-1,1))
	if l.is_colliding():
		shoot(Vector2.LEFT)
	if r.is_colliding():
		shoot(Vector2.RIGHT)

func _on_shoot_timeout() -> void:
	can_shoot = true
