extends Node2D
class_name Stamina

@export
var max_stamina: float = 100
@onready
var stamina: float = max_stamina

@export
var regen: float = 50

var regen_delay: int = 1000
var last_action: int = 0

func can_do() -> bool:
	return stamina > 0

func do(cost: float) -> void:
	stamina -= cost
	last_action = Time.get_ticks_msec()
	if stamina < 0:
		last_action += 250
		stamina = 0

func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - last_action > regen_delay:
		stamina = min(stamina+(delta*regen), max_stamina)
	queue_redraw()
	
func _draw() -> void:
	draw_rect(Rect2(-10, -14, (max(0,stamina)/max_stamina)*20, 2), Color.GREEN)
