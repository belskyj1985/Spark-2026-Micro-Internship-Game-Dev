extends Node2D

func _ready() -> void:
	$GameLoop.play()
	SaveLoad._load()
	
