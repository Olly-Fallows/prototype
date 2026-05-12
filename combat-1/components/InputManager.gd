extends Node2D
class_name InputManager

@export
var movement: Movement
@export
var attackManager: AttackManager

func _input(event: InputEvent) -> void:
	if not attackManager.attacking:
		if event.is_action_pressed("attack"):
			attackManager.start_attack(get_global_mouse_position()-global_position)
	else:
		if event.is_action_released("attack"):
			attackManager.end_attack(get_global_mouse_position()-global_position)
		if event is InputEventMouseMotion:
			attackManager.update_attack(get_global_mouse_position()-global_position)

func _physics_process(_delta: float) -> void:
	movement.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
