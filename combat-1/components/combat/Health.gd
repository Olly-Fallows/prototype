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

func _ready() -> void:
	for h in hurtboxes:
		h.hurt.connect(take_damage)
		
func take_damage(box: Hitbox):
	health -= box.damage
	print(health)
	if health <= 0:
		dead.emit()
