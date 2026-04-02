extends CharacterBody2D
@onready var follow: PathFollow2D = $Path2D/PathFollow2D
@onready var progress_bar: ProgressBar = $ProgressBar

var health :int = 3000
var max_health :int = 3000
var fly_total :int = 0
var status: String = ""
var active :bool = false

func _ready() -> void:
	Global.boss = self
func _physics_process(delta: float) -> void:
	follow.progress += 100 * delta

func get_hit(dmg):
	if status == "":
		modulate = Color(1,.4,.4)
		$HitFlash.start()
	
	$EnemyDmg.play()
	health -= dmg
	progress_bar.value = 100 * float(health)/max_health
	if health <= 0:
		SaveLoad.get_c1(50)
		Global.enemy_die.play()
		$"../door".rise()
		queue_free()

func apply_status(type):
	status = type
	$StatusEffect.start()
	
	if type == "ice":
		$action_Timer.wait_time = 2.0
		modulate = Color(0.201, 0.584, 0.59, 1.0)
	if type == "lightning":
		modulate = Color(1.0, 0.933, 0.0, 1.0)
	if type == "fire":
		$Tick.start()
		modulate = Color(1.0, 0.0, 0.0, 1.0)

func _on_status_effect_timeout() -> void:
	status = ""
	modulate = Color(1,1,1)
	$Tick.stop()
	$action_Timer.wait_time = 1.0

func _on_tick_timeout() -> void:
	get_hit(2)


func _on_hit_flash_timeout() -> void:
	if modulate == Color(1,.4,.4):
		modulate = Color(1,1,1)


func _on_action_timer_timeout() -> void:
	pass # Replace with function body.
