extends Node2D
class_name Movement

@export
var character: CharacterBody2D


var direction: Vector2:
	set(value):
		direction = value.normalized()
