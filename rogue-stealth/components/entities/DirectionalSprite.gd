extends AnimatedSprite2D
class_name DirectionalSprite

@export
var character: CharacterBody2D

var direction: String = "down"
var target_animation: String = "idle":
	set(value):
		target_animation = value

func _ready() -> void:
	if character == null:
		if get_parent() is CharacterBody2D:
			character = get_parent()
		else:
			for c in get_parent().get_children():
				if c is CharacterBody2D:
					character = c
					break

func _process(_delta: float) -> void:
	if abs(character.velocity.x) > abs(character.velocity.y):
		direction = "side"
		flip_h = character.velocity.x < 0
	else:
		if character.velocity.y < 0:
			direction = "up"
			flip_h = false
		else:
			direction = "down"
			flip_h = false
	play(target_animation+"-"+direction)
