extends Area2D
class_name Bullet

@export_enum ("normal", "fire", "ice", "lightning") var type: String = "normal"
@export var speed :int = 100
@export var grav :int = 20
@export var lifetime :float = 2.0
@export var damage :int = 10
@export var phys :bool = false
@onready var sprite: Sprite2D = $sprite

var direction = Vector2.ZERO

func _ready() -> void:
	
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	if lifetime != 0.0:
		timer.start(lifetime)

func _physics_process(delta: float) -> void:
	if !phys:
		position += direction * speed * delta
	else:
		position += direction * delta
		direction.y += grav * delta

func _on_timer_timeout() -> void:
	queue_free()

func setup(p_direction: Vector2, p_damage: int) -> void:
	if !phys:
		direction = p_direction.normalized()
	else:
		direction = p_direction
	damage = p_damage


func _on_body_entered(body: Node2D) -> void:
	body.get_hit(damage)
	if type != "normal":
		body.apply_status(type)
	queue_free()
