extends Control
@onready var c1: Label = $VBoxContainer/c1
@onready var c2: Label = $VBoxContainer/c2

func _ready() -> void:
	Global.UI = self
