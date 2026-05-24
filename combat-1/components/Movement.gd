extends Node2D
class_name Movement

@export
var character: CharacterBody2D
@export
var health: Health

@export
var SPEED: float = 75
var modifier: float = 1.0

@export
var active: bool = true

var knockedback: bool = false
var dodging: bool = false

var direction: Vector2:
	set(value):
		direction = value.normalized()

func _physics_process(delta: float) -> void:
	if not active:
		return
	if knockedback:
		character.velocity = character.velocity.lerp(Vector2(), delta)
		character.move_and_slide()
		return
	if dodging:
		character.velocity = direction*SPEED*2*modifier
		character.move_and_slide()
		return
	var a = 15
	a -= character.velocity.normalized().dot(direction)*5
	character.velocity = character.velocity.lerp(direction*SPEED*modifier, a*delta)
	character.move_and_slide()

func knockback(dir: Vector2, mag: float):
	character.velocity = dir * mag * 200
	get_tree().create_timer(mag/2).timeout.connect(func():
		knockedback = false)

func dodge(dir: Vector2, time: float = 0.5):
	health.invon = true
	dodging = true
	direction = dir
	modifier = 1
	get_tree().create_timer(time).timeout.connect(func():
		health.invon = false
		modifier = 0.5
		get_tree().create_timer(time/1.5).timeout.connect(func():
			modifier = 1
			dodging = false))
