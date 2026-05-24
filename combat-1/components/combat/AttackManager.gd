extends Node2D
class_name AttackManager

signal started_attack
signal finished_attack
signal finished_recoil

@export
var movement: Movement

@export
var attack = preload("uid://cjm7runkggjw4")

@export_flags_2d_physics
var layer: int = 0
@export_flags_2d_physics
var mask: int = 0

var start_time: int = 0
@export
var min_time: int = 500
@export
var max_time: int = 2000

@export
var recoil_time: float = 0.75

var attacking: bool = false
var recoiling: bool = false
var direction: Vector2 = Vector2()

@export
var turn_rate: float = 0.2

func start_attack(dir: Vector2 = Vector2()):
	if attacking:
		return
	start_time = Time.get_ticks_msec()
	movement.modifier = 0.75
	attacking = true
	direction = dir
	started_attack.emit()
	queue_redraw()
	
func update_attack(dir: Vector2 = Vector2()):
	direction = direction.lerp(dir, turn_rate)
	queue_redraw()
	
func end_attack(dir: Vector2 = direction):
	direction = direction.lerp(dir, turn_rate*2)
	if not attacking:
		return
	if Time.get_ticks_msec()-start_time < min_time:
		get_tree().create_timer(((start_time+min_time)-Time.get_ticks_msec())/1000.0).timeout.connect(end_attack)
		return
	attacking = false
	recoiling = true
	finished_attack.emit()
	get_tree().create_timer(recoil_time).timeout.connect(func():
		movement.modifier = 1
		recoiling = false
		finished_recoil.emit()
		queue_redraw())
	queue_redraw()
	var a: Hitbox = attack.instantiate()
	a.collision_layer = layer
	a.collision_mask = mask
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
		end_attack(direction)

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
