extends Node2D

@onready var v_box_container: VBoxContainer = $UI/VBoxContainer
@onready var stats: VBoxContainer = $UI/stats
@onready var ui: Control = $UI
var detected: bool = false

@onready var shop_keeper_sprite: Sprite2D = $ShopKeeperSprite
@export var pace_distance: float = 80.0 
@export var max_speed: float = 40.0
@export var lean_amount: float = 0.08
@export var acceleration: float = 4.0
var start_x: float
var direction: int = 1
var current_speed: float = 0.0

func _physics_process(delta: float) -> void:
	if detected:
		v_box_container.position.y = lerpf(v_box_container.position.y,-150,.08)
		stats.position.y = lerpf(stats.position.y,-150,.08)
	else:
		v_box_container.position.y = lerpf(v_box_container.position.y,-1000,.08)
		stats.position.y = lerpf(stats.position.y,-1000,.01)
	
	if detected:
		# Smoothly slow to stop
		current_speed = lerpf(current_speed, 0.0, acceleration * delta)
	else:
		# Smoothly accelerate to max speed
		current_speed = lerpf(current_speed, max_speed, acceleration * delta)
	
	# --- Movement ---
	global_position.x += direction * current_speed * delta
	
	# Check bounds (only change direction if moving)
	if not detected:
		if global_position.x > start_x + pace_distance:
			direction = -1
		elif global_position.x < start_x - pace_distance:
			direction = 1
	
	# Flip sprite
	shop_keeper_sprite.flip_h = direction < 0
	
	# Lean based on movement speed (leans less when stopping)
	var target_lean = lean_amount * direction * (current_speed / max_speed)
	
	shop_keeper_sprite.rotation = lerpf(
		shop_keeper_sprite.rotation,
		target_lean,
		6 * delta
	)

func _ready() -> void:
	start_x = global_position.x
	v_box_container.visible = false
	update_buttons()

func _on_area_2d_body_entered(body: Node2D) -> void:
	v_box_container.visible = true
	detected = true
	update_buttons()


func _on_area_2d_body_exited(body: Node2D) -> void:
	#v_box_container.visible = false
	detected = false
	$UI/VBoxContainer/ice/ice_button.release_focus()
	$UI/VBoxContainer/fire/fire_button.release_focus()
	$UI/VBoxContainer/lightning/lightning_button.release_focus()

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
	
	if SaveLoad.contents_to_save["hp"] < 5:
		$UI/stats/hp/hp_button/Label.text = str(120 + 20 * SaveLoad.contents_to_save["hp"]) + "sc"
		$UI/stats/hp/hp_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
	else:
		$UI/stats/hp/hp_button/Label.text = "MAX"
		$UI/stats/hp/hp_button/Label.label_settings.font_color =  Color(0.0, 1.0, 0.883, 1.0)
	
	if SaveLoad.contents_to_save["def"] < 2:
		$UI/stats/def/def_button/Label.text = str(120 + 40 * SaveLoad.contents_to_save["def"]) + "sc"
		$UI/stats/def/def_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
	else:
		$UI/stats/def/def_button/Label.text = "MAX"
		$UI/stats/def/def_button/Label.label_settings.font_color =  Color(0.0, 1.0, 0.883, 1.0)
	
	if SaveLoad.contents_to_save["dmg"] < 5:
		$UI/stats/dmg/dmg_button/Label.text = str(120 + 60 * SaveLoad.contents_to_save["dmg"]) + "sc"
		$UI/stats/dmg/dmg_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
	else:
		$UI/stats/dmg/dmg_button/Label.text = "MAX"
		$UI/stats/dmg/dmg_button/Label.label_settings.font_color =  Color(0.0, 1.0, 0.883, 1.0)

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
			
			if SaveLoad.contents_to_save["ice"] == 2:
				SaveLoad.contents_to_save["ice"] = 1
			if SaveLoad.contents_to_save["lightning"] == 2:
				SaveLoad.contents_to_save["lightning"] = 1
		2:
			SaveLoad.contents_to_save["fire"] = 1
			Global.player.switch_bullet("")
	update_buttons()


func _on_ice_button_pressed() -> void:
	print(SaveLoad.contents_to_save["ice"])
	match SaveLoad.contents_to_save["ice"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 120:
				SaveLoad.get_c1(-120)
				SaveLoad.contents_to_save["ice"] = 1
		1:
			SaveLoad.contents_to_save["ice"] = 2
			Global.player.switch_bullet("ice")
			
			if SaveLoad.contents_to_save["fire"] == 2:
				SaveLoad.contents_to_save["fire"] = 1
			if SaveLoad.contents_to_save["lightning"] == 2:
				SaveLoad.contents_to_save["lightning"] = 1
		2:
			SaveLoad.contents_to_save["ice"] = 1
			Global.player.switch_bullet("")
	update_buttons()


func _on_lightning_button_pressed() -> void:
	print(SaveLoad.contents_to_save["lightning"])
	match SaveLoad.contents_to_save["lightning"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 120:
				SaveLoad.get_c1(-120)
				SaveLoad.contents_to_save["lightning"] = 1
		1:
			SaveLoad.contents_to_save["lightning"] = 2
			Global.player.switch_bullet("lightning")
			
			if SaveLoad.contents_to_save["ice"] == 2:
				SaveLoad.contents_to_save["ice"] = 1
			if SaveLoad.contents_to_save["fire"] == 2:
				SaveLoad.contents_to_save["fire"] = 1
		2:
			SaveLoad.contents_to_save["lightning"] = 1
			Global.player.switch_bullet("")
	update_buttons()


func _on_hp_button_pressed() -> void:
	if SaveLoad.contents_to_save["hp"] < 5 && SaveLoad.contents_to_save["c1"] >= (120 + 20 * SaveLoad.contents_to_save["hp"]):
		SaveLoad.get_c1(-120 - 20 * SaveLoad.contents_to_save["hp"])
		SaveLoad.contents_to_save["hp"] += 1
		update_buttons()
		SaveLoad.contents_to_save["cur_hp"] = Global.player.health + 20
		Global.player.load_save_data()
		


func _on_def_button_pressed() -> void:
	if SaveLoad.contents_to_save["def"] < 2 && SaveLoad.contents_to_save["c1"] >= (120 + 40 * SaveLoad.contents_to_save["def"]):
		SaveLoad.get_c1(-120 - 40 * SaveLoad.contents_to_save["def"])
		SaveLoad.contents_to_save["def"] += 1
		update_buttons()
		Global.player.load_save_data()


func _on_dmg_pressed() -> void:
	if SaveLoad.contents_to_save["dmg"] < 5 && SaveLoad.contents_to_save["c1"] >= (120 + 60 * SaveLoad.contents_to_save["dmg"]):
		SaveLoad.get_c1(-120 - 60 * SaveLoad.contents_to_save["dmg"])
		SaveLoad.contents_to_save["dmg"] += 1
		update_buttons()
		Global.player.load_save_data()
