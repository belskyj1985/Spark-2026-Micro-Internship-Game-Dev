extends CharacterBody2D

func get_hit(dmg):
	if Global.boss.active:
		Global.boss.get_hit(dmg)
func apply_status(type):
	Global.boss.apply_status(type)
