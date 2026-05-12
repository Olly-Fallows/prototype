extends Node2D
class_name AttackManager

@export
var movement: Movement

@export
var attack = preload("uid://cjm7runkggjw4")

var start_time: int = 0
@export
var min_time: int = 500
@export
var max_time: int = 2000

var attacking: bool = false
var direction: Vector2 = Vector2()

func start_attack(dir: Vector2 = Vector2()):
	if attacking:
		return
	start_time = Time.get_ticks_msec()
	movement.modifier = 0.75
	attacking = true
	direction = dir
	queue_redraw()
	
func update_attack(dir: Vector2 = Vector2()):
	direction = dir
	queue_redraw()
	
func end_attack(dir: Vector2):
	if not attacking:
		return
	attacking = false
	get_tree().create_timer(0.25).timeout.connect(func():
		movement.modifier = 1
		queue_redraw())
	queue_redraw()
	if Time.get_ticks_msec()-start_time < min_time:
		return
	direction = dir
	var a = attack.instantiate()
	a.rotation = direction.angle()
	#a.damage = 1 + min(3, (float(Time.get_ticks_msec()-start_time) / float(max_time)))
	#print(a.damage)
	add_child(a)
	a.global_position = global_position

func _physics_process(_delta: float) -> void:
	if not attacking:
		return
	if Time.get_ticks_msec()-start_time > min_time:
		movement.modifier = 0.5
	if Time.get_ticks_msec()-start_time > max_time:
		movement.modifier = 0.25	

func _process(_delta: float) -> void:
	if attacking:
		queue_redraw()

func _draw() -> void:
	if not attacking:
		return
	var angle = direction.angle()
	var colour = Color.RED
	if Time.get_ticks_msec()-start_time >= min_time:
		colour = Color.WHITE
	draw_arc(Vector2(), 16, angle-deg_to_rad(15), angle+deg_to_rad(15), 5, colour, 5)
