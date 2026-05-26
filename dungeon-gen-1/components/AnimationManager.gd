extends AnimatedSprite2D

@export
var movement: Movement

var facing: String = "down"

func _process(_delta: float) -> void:
	if movement.direction.length() != 0:
		if movement.direction.x < 0:
			facing = "side"
			flip_h = true
		elif movement.direction.x > 0:
			facing = "side"
			flip_h = false
		elif movement.direction.y < 0:
			facing = "up"
		elif movement.direction.y > 0:
			facing = "down"
		play(facing+"-run", max((movement.modifier*movement.SPEED)/100,0.5))
	else:
		play(facing+"-idle")
