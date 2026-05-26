extends Node2D
class_name InputManager

@export
var movement: Movement

func _physics_process(_delta: float) -> void:
	if not movement.dodging:
		movement.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
