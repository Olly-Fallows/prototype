extends Node2D
class_name AI

@onready
var target: CharacterBody2D = get_tree().get_first_node_in_group("player")

@export
var movement: Movement

@export
var attacks: Array[AttackManager]

func _ready() -> void:
	attacks[1].finished_attack.connect(func():
		attacks[2].start_attack((target.global_position-global_position).normalized())
	)
	attacks[2].finished_attack.connect(func():
		attacks[3].start_attack((target.global_position-global_position).normalized())
	)

func _physics_process(_delta: float) -> void:
	if target == null:
		return
	if is_attacking() < 0:
		var dir = (target.global_position-global_position).normalized()
		movement.direction += dir
	else:
		movement.direction = Vector2()
	
	if (target.global_position-global_position).length() < 64:
		if is_attacking() >= 0:
			attacks[is_attacking()].update_attack((target.global_position-global_position).normalized())
		if is_attacking() < 0 and is_recoiling() < 0:
			match (randi_range(0, 2)):
				0:
					attacks[0].start_attack((target.global_position-global_position).normalized())
				1:
					attacks[1].start_attack((target.global_position-global_position).normalized())
				2:
					attacks[3].start_attack((target.global_position-global_position).normalized())
	else:
		if is_attacking() >= 0:
			attacks[is_attacking()].end_attack((target.global_position-global_position).normalized())

func is_attacking() -> int:
	for a in range(attacks.size()):
		if attacks[a].attacking:
			return a
	return -1

func is_recoiling() -> int:
	for a in range(attacks.size()):
		if attacks[a].recoiling:
			return a
	return -1
