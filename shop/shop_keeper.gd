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
	update_buttons()

func _on_area_2d_body_entered(body: Node2D) -> void:
	v_box_container.visible = true
	detected = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	#v_box_container.visible = false
	detected = false

func update_buttons() -> void:
	match SaveLoad.contents_to_save["fire"]:
		0:
			$UI/VBoxContainer/fire/fire_button/Label.text = "120sc"
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/fire/fire_button/Label.text = "Equip"
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/fire/fire_button/Label.text = "Unequip"
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
		
	match SaveLoad.contents_to_save["ice"]:
		0:
			$UI/VBoxContainer/ice/ice_button/Label.text = "120sc"
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/ice/ice_button/Label.text = "Equip"
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/ice/ice_button/Label.text = "Unequip"
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
	match SaveLoad.contents_to_save["lightning"]:
		0:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "120sc"
			$UI/VBoxContainer/lightning/lightning_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "Equip"
			$UI/VBoxContainer/lightning/lightning_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "Unequip"
			$UI/VBoxContainer/lightning/lightning_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)

func _on_fire_button_pressed() -> void:
	print(SaveLoad.contents_to_save["fire"])
	match SaveLoad.contents_to_save["fire"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 120:
				SaveLoad.get_c1(-120)
				SaveLoad.contents_to_save["fire"] = 1
		1:
			SaveLoad.contents_to_save["fire"] = 2
			Global.player.switch_bullet("fire")
		2:
			SaveLoad.contents_to_save["fire"] = 1
			Global.player.switch_bullet("")
	update_buttons()
