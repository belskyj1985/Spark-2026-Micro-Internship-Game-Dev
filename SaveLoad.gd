extends Node
const save_location = "user://SaveFile.json"

var contents_to_save :Dictionary = {
	"c1": 0,
	"c2": 0,
	"fire": 0,
	"ice": 0,
	"lightning": 0,
	"hp": 0,
	"def": 0,
	"dmg": 0,
	"cur_hp": 100,
	"melee": 0,
	"dash": 0,
	"dj": 0
}

func get_c1(n):
	contents_to_save["c1"] += n
	Global.UI.c1.text = str(contents_to_save["c1"]) + "sc"

func get_c2(n):
	contents_to_save["c2"] += n
	Global.UI.c2.text = str(contents_to_save["c2"])

func _ready() -> void:
	pass#_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save.c1 = save_data.c1
		contents_to_save.c2 = save_data.c2
		
		contents_to_save.fire = save_data.fire
		contents_to_save.ice = save_data.ice
		contents_to_save.lightning = save_data.lightning
		
		contents_to_save.hp = save_data.hp
		contents_to_save.def = save_data.def
		contents_to_save.dmg = save_data.dmg
		
		contents_to_save.cur_hp = save_data.cur_hp
		
		contents_to_save.melee = save_data.melee
		contents_to_save.dj = save_data.dj
		contents_to_save.dash = save_data.dash
		
		if save_data.fire == 2:
			Global.player.switch_bullet("fire")
		elif save_data.ice == 2:
			Global.player.switch_bullet("ice")
		elif save_data.lightning == 2:
			Global.player.switch_bullet("lightning")
		get_c1(0)
