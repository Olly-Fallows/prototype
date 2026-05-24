extends Node2D
class_name Health

signal dead

@export
var movement: Movement

@export
var max_health: float = 10
@onready
var health := max_health

@export
var hurtboxes: Array[Hurtbox] = []

@export
var delete_on_kill: bool = true

var invon: bool = false

func _ready() -> void:
	for h in hurtboxes:
		h.hurt.connect(take_damage)
	if delete_on_kill:
		dead.connect(get_parent().queue_free)
		
func take_damage(box: Hitbox):
	if invon:
		return
	health -= box.damage
	queue_redraw()
	movement.knockback((global_position-box.global_position).normalized(), box.damage)
	if health <= 0:
		dead.emit()

func _draw() -> void:
	draw_rect(Rect2(-10, -16, (health/max_health)*20, 2), Color.RED)
