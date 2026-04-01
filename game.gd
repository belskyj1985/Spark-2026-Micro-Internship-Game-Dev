extends Node2D

func _ready() -> void:
	$GameLoop.play()
	Global.music = $GameLoop
	SaveLoad._load()
