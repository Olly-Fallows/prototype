extends Area2D
class_name Hitbox

signal hit(box: Hurtbox)
signal parried(box: Hurtbox)

@export
var damage: float = 1

func _ready() -> void:
	area_entered.connect(check_hit)
	
func check_hit(area: Area2D):
	if area is Hurtbox:
		if area.parrying:
			parried.emit(area)
		else:
			hit.emit(area)
