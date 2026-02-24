extends Node2D

@onready var v_box_container: VBoxContainer = $UI/VBoxContainer
@onready var ui: Control = $UI
var detected: bool = false

func _physics_process(delta: float) -> void:
	if detected:
		v_box_container.position.y = lerpf(v_box_container.position.y,-150,.08)
	else:
		v_box_container.position.y = lerpf(v_box_container.position.y,-1000,.01)

func _ready() -> void:
	v_box_container.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	v_box_container.visible = true
	detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	#v_box_container.visible = false
	detected = false


func _on_button_1_pressed() -> void:
	if SaveLoad.contents_to_save["c1"] >= 10:
		SaveLoad.get_c1(-10)
		print("you lost 10 bucks")
		
