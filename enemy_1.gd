extends CharacterBody2D
const BulletScene = preload("res://enemy_1_bullet.tscn")
@onready var range: Area2D = $range
@onready var timer: Timer = $Timer

var active :bool = false
var health :int = 100





func _on_range_body_entered(body: Node2D) -> void:
	active = true
	timer.start()

func _on_range_body_exited(body: Node2D) -> void:
	timer.stop()
	active = false


func _on_timer_timeout() -> void:
	var bullet_instance: Bullet = BulletScene.instantiate()
	get_tree().current_scene.add_child(bullet_instance)
	var v = 600
	var g = bullet_instance.grav
	var h = 2*(v*v)/(2*g) + (Global.player.global_position - global_position).y + v/sqrt(2)
	var t = (v + sqrt(v-2 * g * (Global.player.global_position - global_position).y))/g
	var x_vel = (
		(Global.player.global_position - global_position).x/(sqrt((2*h)/g))
	)
	
	bullet_instance.setup(Vector2(x_vel,-v), 30)
	#bullet_instance.setup(Global.player.global_position-global_position, 30)
	bullet_instance.body_entered.connect(bullet_instance._on_body_entered)
	bullet_instance.global_position = global_position
	print(x_vel)
