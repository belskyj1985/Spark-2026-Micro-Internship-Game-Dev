extends Node2D

@onready var v_box_container: VBoxContainer = $UI/VBoxContainer
@onready var stats: VBoxContainer = $UI/stats
@onready var abilities: VBoxContainer = $UI/abilities
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
var target_y = -150
func _physics_process(delta: float) -> void:
	$UI/notice.modulate.a = lerpf($UI/notice.modulate.a,0.0,0.02)
	if detected:
		ui.modulate.a = lerpf(ui.modulate.a,1.0,0.18)
		v_box_container.position.y = lerpf(v_box_container.position.y,target_y,.08)
		stats.position.y = lerpf(stats.position.y,target_y,.08)
		abilities.position.y = lerpf(abilities.position.y,target_y,.08)
	else:
		ui.modulate.a = lerpf(ui.modulate.a,0.0,0.18)
		v_box_container.position.y = lerpf(v_box_container.position.y,-1000,.01)
		stats.position.y = lerpf(stats.position.y,-1000,.01)
		abilities.position.y = lerpf(abilities.position.y,-1000,.01)
	
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
	
	$UI/stats/hp/hp_button.release_focus()
	$UI/stats/def/def_button.release_focus()
	$UI/stats/dmg/dmg_button.release_focus()
	
	$UI/abilities/melee/melee_button.release_focus()
	$UI/abilities/dj/dj_button.release_focus()
	$UI/abilities/dash/dash_button.release_focus()

func update_buttons() -> void:
	match SaveLoad.contents_to_save["fire"]:
		0:
			$UI/VBoxContainer/fire/fire_button/Label.text = "120sc"
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/fire/fire_button/Label.text = "Equip"
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/fire/fire_button/Label.text = "Uneq."
			$UI/VBoxContainer/fire/fire_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
		
	match SaveLoad.contents_to_save["ice"]:
		0:
			$UI/VBoxContainer/ice/ice_button/Label.text = "120sc"
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/ice/ice_button/Label.text = "Equip"
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/ice/ice_button/Label.text = "Uneq."
			$UI/VBoxContainer/ice/ice_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
	match SaveLoad.contents_to_save["lightning"]:
		0:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "120sc"
			$UI/VBoxContainer/lightning/lightning_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "Equip"
			$UI/VBoxContainer/lightning/lightning_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/VBoxContainer/lightning/lightning_button/Label.text = "Uneq."
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
	
	match SaveLoad.contents_to_save["melee"]:
		0:
			$UI/abilities/melee/melee_button/Label.text = "300sc"
			$UI/abilities/melee/melee_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/abilities/melee/melee_button/Label.text = "Equip"
			$UI/abilities/melee/melee_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/abilities/melee/melee_button/Label.text = "Uneq."
			$UI/abilities/melee/melee_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
	
	match SaveLoad.contents_to_save["dj"]:
		0:
			$UI/abilities/dj/dj_button/Label.text = "400sc"
			$UI/abilities/dj/dj_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/abilities/dj/dj_button/Label.text = "Equip"
			$UI/abilities/dj/dj_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/abilities/dj/dj_button/Label.text = "Uneq."
			$UI/abilities/dj/dj_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)
	
	match SaveLoad.contents_to_save["dash"]:
		0:
			$UI/abilities/dash/dash_button/Label.text = "500sc"
			$UI/abilities/dash/dash_button/Label.label_settings.font_color = Color(1.0, 0.753, 0.29, 1.0)
		1:
			$UI/abilities/dash/dash_button/Label.text = "Equip"
			$UI/abilities/dash/dash_button/Label.label_settings.font_color = Color(1.0, 1.0, 1.0, 1.0)
		2:
			$UI/abilities/dash/dash_button/Label.text = "Uneq."
			$UI/abilities/dash/dash_button/Label.label_settings.font_color = Color(0.0, 1.0, 0.883, 1.0)

func _on_fire_button_pressed() -> void:
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


func _on_melee_button_pressed() -> void:
	match SaveLoad.contents_to_save["melee"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 400:
				SaveLoad.get_c1(-400)
				SaveLoad.contents_to_save["melee"] = 1
		1:
			$UI/notice.modulate.a = 1.0
			SaveLoad.contents_to_save["melee"] = 2
			Global.player.switch_bullet("melee")
		2:
			SaveLoad.contents_to_save["melee"] = 1
	update_buttons()


func _on_dj_button_pressed() -> void:
	match SaveLoad.contents_to_save["dj"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 500:
				SaveLoad.get_c1(-500)
				SaveLoad.contents_to_save["dj"] = 1
		1:
			$UI/notice.modulate.a = 1.0
			SaveLoad.contents_to_save["dj"] = 2
			Global.player.switch_bullet("dj")
		2:
			SaveLoad.contents_to_save["dj"] = 1
	update_buttons()


func _on_dash_button_pressed() -> void:
	match SaveLoad.contents_to_save["dash"]:
		0:
			if SaveLoad.contents_to_save["c1"] >= 300:
				SaveLoad.get_c1(-300)
				SaveLoad.contents_to_save["dash"] = 1
		1:
			SaveLoad.contents_to_save["dash"] = 2
			Global.player.switch_bullet("dash")
			$UI/notice.modulate.a = 1.0
		2:
			SaveLoad.contents_to_save["dash"] = 1
	update_buttons()
