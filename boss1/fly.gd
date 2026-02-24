extends CharacterBody2D
var health :int = 60
var damage :int = 10
var spd :int = 10
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var boss: CharacterBody2D = get_tree().root.get_node("frog")
var status: String = ""

func _physics_process(delta: float) -> void:
	var target_vel :Vector2 = (global_position - Global.player.global_position).normalized() * delta * -10000
	velocity = velocity.move_toward(target_vel,10)
	move_and_slide()

func get_hit(dmg):
	health -= dmg
	if health <= 0:
		Global.boss.fly_total -= 1
		queue_free()
	
	if status == "":
		print("NO STATUS")
		modulate = Color(1,.4,.4)
		$HitFlash.start()

func apply_status(type):
	status = type
	$StatusEffect.start()
	$Tick.start()
	if status == "ice":
		spd /= 2
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if status == "lightning":
		modulate = Color(1.0, 0.978, 0.34, 1.0)
		damage = 5

func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)

func _on_status_effect_timeout() -> void:
	if status == "ice":
		spd *= 2
	status = ""
	modulate = Color(1,1,1)
	$Tick.stop()
	damage = 10


func _on_tick_timeout() -> void:
	if status == "fire":
		get_hit(2)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Global.player.get_hit(global_position,damage,20)
