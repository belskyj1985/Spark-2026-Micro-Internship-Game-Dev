extends Area2D
var shaking = false
@onready var sprite: TileMapLayer = $TileMapLayer

@export var scene :String = "res://game.tscn"
func _on_body_entered(body: Node2D) -> void:
	SaveLoad._save()
	get_tree().change_scene_to_file(scene)

func rise():
	shaking = true
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y",position.y - 96,2.0)
	await tween.finished
	shaking = false

func _physics_process(delta: float) -> void:
	#velocity.y += 200 * delta
	if shaking:
		sprite.position.x = 16 + randi_range(-8,8)
