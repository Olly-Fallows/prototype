extends Node2D
class_name Movement

@export
var character: CharacterBody2D

@export
var SPEED: float = 75
var modifier: float = 1.0

@export
var active: bool = true

var direction: Vector2:
	set(value):
		direction = value.normalized()

func _physics_process(delta: float) -> void:
	if not active:
		return
	var a = 15
	a -= character.velocity.normalized().dot(direction)*5
	character.velocity = character.velocity.lerp(direction*SPEED*modifier, a*delta)
	character.move_and_slide()
