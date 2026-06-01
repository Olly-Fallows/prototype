extends Node2D
class_name Movement

@export
var character: CharacterBody2D

@export
var speed: float = 50
@export
var acceloration: float = 5

var target_dir: Vector2:
	set (value):
		target_dir = value.normalized()

func _ready() -> void:
	if character == null:
		if get_parent() is CharacterBody2D:
			character = get_parent()
		else:
			for c in get_parent().get_children():
				if c is CharacterBody2D:
					character = c
					break

func _physics_process(delta: float) -> void:
	if target_dir == Vector2():
		character.velocity = character.velocity.lerp(Vector2(), acceloration*delta*2)
	else:
		character.velocity = character.velocity.lerp(target_dir*speed, acceloration*delta*2)
	character.move_and_slide()

func stop() -> void:
	character.velocity = Vector2()
	target_dir = Vector2()
