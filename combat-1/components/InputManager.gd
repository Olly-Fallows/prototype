extends Node2D
class_name InputManager

@export
var movement: Movement
@export
var attackManager: AttackManager
@export
var stamina: Stamina

@export
var dodge_cost: float = 20
@export
var attack_cost: float = 50

var attack_queued: bool = false

func _ready() -> void:
	attackManager.finished_attack.connect(func():
		if attack_queued:
			attackManager.start_attack(get_global_mouse_position()-global_position)
			if not Input.is_action_pressed("attack"):
				attackManager.end_attack(get_global_mouse_position()-global_position)
			attack_queued = false)

func _input(event: InputEvent) -> void:
	if not attackManager.attacking:
		if event.is_action_pressed("dodge"):
			if not movement.dodging:
				if stamina.can_do():
					movement.dodge(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"), 0.2)
					stamina.do(dodge_cost)
		if event.is_action_pressed("attack"):
			if stamina.can_do():
				attackManager.start_attack(get_global_mouse_position()-global_position)
				stamina.do(attack_cost)
	else:
		if event.is_action_pressed("attack"):
			attack_queued = true
			get_tree().create_timer(0.5).timeout.connect(func():
				attack_queued = false)
		if event.is_action_released("attack"):
			attackManager.end_attack(get_global_mouse_position()-global_position)
		if event is InputEventMouseMotion:
			attackManager.update_attack(get_global_mouse_position()-global_position)

func _physics_process(_delta: float) -> void:
	if not movement.dodging:
		movement.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
