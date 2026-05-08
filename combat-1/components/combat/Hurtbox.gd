extends Area2D
class_name Hurtbox

signal hurt(box: Hitbox)
signal parried(box: Hitbox)

var parrying: bool = false

func _ready() -> void:
	area_entered.connect(check_hit)
	
func check_hit(area: Area2D):
	if area is Hitbox:
		if parrying:
			parried.emit(area)
		else:
			hurt.emit(area)
