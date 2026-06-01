extends Node2D
class_name InputManager

@export
var movement: Movement

func _ready() -> void:
	if movement == null:
		if get_parent() is Movement:
			movement = get_parent()
		else:
			for c in get_parent().get_children():
				if c is Movement:
					movement = c
					break
					
func _physics_process(_delta: float) -> void:
	movement.target_dir = Input.get_vector("left","right","up","down")
