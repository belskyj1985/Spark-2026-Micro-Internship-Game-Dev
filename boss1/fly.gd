extends CharacterBody2D
var health :int = 60
var damage :int = 10
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func _physics_process(delta: float) -> void:
	var target_vel :Vector2 = (global_position - Global.player.global_position).normalized() * delta * -10000
	velocity = velocity.move_toward(target_vel,10)
	move_and_slide()

func get_hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("HIT PLAYER")
	Global.player.get_hit(global_position,damage,20)
