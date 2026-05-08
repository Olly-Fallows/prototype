extends Node2D
class_name Health

signal dead

@export
var hurtboxes: Array[Hurtbox] = []

@export
var max_health: float = 10
@onready
var health := max_health

func _ready() -> void:
	for h in hurtboxes:
		h.hurt.connect(take_damage)
		
func take_damage(box: Hitbox):
	health -= box.damage
	if health <= 0:
		dead.emit()
