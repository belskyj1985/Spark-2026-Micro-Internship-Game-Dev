extends CharacterBody2D

@onready var saw: Sprite2D = $Saw
@onready var saw2: Sprite2D = $Saw2
@onready var saw3: Sprite2D = $Saw3
@onready var left_check: RayCast2D = $left_check
@onready var right_check: RayCast2D = $right_check
@onready var hurt_box: Area2D = $hurtBox

var active :bool = false
var health :int = 400
var status: String = ""

var dir :int = 1

func _physics_process(delta: float) -> void:
	saw.rotation += PI * delta
	saw2.rotation += PI * delta
	saw3.rotation += PI * delta
	if is_on_wall():
		dir *= -1
	if !left_check.is_colliding():
		dir = 1
	if !right_check.is_colliding():
		dir = -1
	velocity.x = 15000 * delta * dir
	velocity.y = 100
	move_and_slide()

func get_hit(dmg):
	$EnemyDmg.play()
	print(dmg)
	health -= dmg
	if health <= 0:
		SaveLoad.get_c1(10)
		Global.enemy_die.play()
		queue_free()
	
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()


func apply_status(type):
	status = type
	$StatusEffect.start()
	
	if type == "ice":
		#$Timer.wait_time = 2.0
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if type == "lightning":
		
		modulate = Color(1.0, 0.933, 0.0, 1.0)
	if type == "fire":
		#$Timer.wait_time = 2.0
		$Tick.start()
		modulate = Color(1.0, 0.0, 0.0, 1.0)

func _on_HitFlash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)


func _on_status_effect_timeout() -> void:
	print("modulate done")
	status = ""
	modulate = Color(1,1,1)
	$Tick.stop()
	#$Timer.wait_time = 1.0


func _on_tick_timeout() -> void:
	get_hit(2)


func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)


func _on_hurt_box_body_entered(body: Node2D) -> void:
	body.get_hit(30)
