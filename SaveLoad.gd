extends Node
const save_location = "user://SaveFile.json"

var contents_to_save :Dictionary = {
	"c1": 0,
	"c2": 0,
}

func get_c1(n):
	contents_to_save["c1"] += n
	Global.UI.c1.text = str(contents_to_save["c1"])

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
		get_c1(0)
