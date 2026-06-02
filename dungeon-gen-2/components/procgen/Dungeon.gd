extends Node2D
class_name Dungeon

@export
var size: Vector2i = Vector2i(320,180)
@export
var display_scale: int = 2
@export_range(0, 0.99, 0.01)
var min_padding: float = 0.05
@export_range(0, 0.99, 0.01)
var max_padding: float = 0.25

var root: Room

var corridors: Array[Corridor] = []

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		root.cellular_automata(0.5, 1)
		queue_redraw()

func _ready() -> void:
	#seed(1)
	
	root = Room.new()
	root.size = size
	root.position = Vector2i()
	root.min_padding = min_padding
	root.max_padding = max_padding
	
	for a in range(75):
		root.partition(2)
	root.cellular_automata(0.55, 5, true, true)
	
	queue_redraw()

func _draw() -> void:
	var space = root.to_space()
	for x in range(space.size.x):
		for y in range(space.size.y):
			if space.cells[x][y] == 1:
				draw_rect(Rect2(x*display_scale, y*display_scale, display_scale, display_scale), Color.RED)
	#for c in root.make_corridors():
		#if c != null:
			#draw_line(c.start*display_scale, c.end*display_scale, Color.BLACK, 2)
