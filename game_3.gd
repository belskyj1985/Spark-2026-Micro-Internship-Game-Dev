extends Node2D

func _ready() -> void:
	$GameLoop.play()
	Global.music = $GameLoop
	SaveLoad._load()
	Global.player.health = 100 + (SaveLoad.contents_to_save["hp"]) * 20
