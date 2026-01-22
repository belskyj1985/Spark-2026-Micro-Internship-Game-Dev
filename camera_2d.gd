extends Camera2D
func _ready() -> void:
	Global.camera = self

func _physics_process(delta: float) -> void:
	position = global_position.move_toward(Global.player.global_position, 100 * (global_position - Global.player.global_position).length_squared()/1000 * delta)
