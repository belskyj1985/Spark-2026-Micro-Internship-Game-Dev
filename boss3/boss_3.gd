extends CharacterBody2D
@onready var follow: PathFollow2D = $Path2D/PathFollow2D
@onready var progress_bar: ProgressBar = $ProgressBar

var health :int = 4000
var max_health :int = 4000
var fly_total :int = 0
var status: String = ""
var active :bool = false
var bullet_damage = 15
const bullet = preload("res://boss3/boss_3_bullet.tscn")
const enemy = preload("res://enemy3/enemy3.tscn")
var dir :int = 1

func _ready() -> void:
	Global.boss = self
func _physics_process(delta: float) -> void:
	follow.progress += 100 * delta * dir
	if follow.progress_ratio == 1 || follow.progress_ratio == 0:
		dir *= -1

func get_hit(dmg):
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()
	
	$EnemyDmg.play()
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		SaveLoad.get_c1(50)
		Global.enemy_die.play()
		$"../door".rise()
		Global.camera.focused = false
		queue_free()

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

func activate():
	active = true
	

func shoot(bullet_offset: Vector2 = Vector2.ZERO):
	var bullet_instance: Bullet = bullet.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	bullet_instance.setup(Vector2(-1, 0), bullet_damage)
	#bullet_instance.sprite.rotation = Vector2(sign(bullet_offset.x), 0).angle() + angle_offset
	bullet_instance.global_position = global_position + bullet_offset
	bullet_instance.speed = 800

var actions = 0
func _on_action_timer_timeout() -> void:
	actions += 1
	if actions % 10 == 0:
		pass
	
	if actions % 5 == 0:
		var instance = enemy.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position.x = Global.player.global_position.x
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(instance, "position:y",Global.player.global_position.y,2.0)
		await tween.finished
	
	match (actions%3):
		0:
			shoot(Vector2(-88,-128))
		1:
			shoot(Vector2(-88,0))
		2:
			shoot(Vector2(-88, 128))
