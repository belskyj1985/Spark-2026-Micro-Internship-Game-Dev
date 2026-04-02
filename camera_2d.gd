extends Camera2D
var focused :bool = false
var target_pos :Vector2 = Vector2.ZERO
func _ready() -> void:
	Global.camera = self

func _physics_process(delta: float) -> void:
	if !focused:
		zoom = Vector2(1.4,1.4)
		position = lerp(global_position,Global.player.global_position, 0.2)
	else:
		position = lerp(global_position,target_pos, 0.2)
		
	#position = global_position.move_toward(Global.player.global_position, 100 * (global_position - Global.player.global_position).length_squared()/1000 * delta)
