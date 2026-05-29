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
	root = Room.new()
	root.size = size
	root.position = Vector2i()
	root.min_padding = min_padding
	root.max_padding = max_padding
	
	#root.cellular_automata(0.5, 10)
	for a in range(50):
		root.partition([2].pick_random())
	
	corridors = make_corridors(root)
	print(corridors)
	
	queue_redraw()

func make_corridors(room: Room) -> Array[Corridor]:
	if room.subrooms.size() == 0:
		return []
	var cs: Array[Corridor] = []
	for r in room.subrooms:
		cs.append_array(make_corridors(r))
	for a in range(room.subrooms.size()-1):
		var start_options: Array[Room] = room.subrooms[a].end_rooms()
		var end_options: Array[Room] = room.subrooms[a+1].end_rooms()
		var start = start_options[0]
		var end = end_options[0]
		for s in start_options:
			for e in end_options:
				if (start.center()-end.center()).length() > (s.center()-e.center()).length():
					start = s
					end = e
		cs.append(Corridor.from(start, end))
	return cs

func _draw() -> void:
	var space = root.to_space()
	for x in range(space.size.x):
		for y in range(space.size.y):
			if space.cells[x][y] == 1:
				draw_rect(Rect2(x*display_scale, y*display_scale, display_scale, display_scale), Color.RED)
	for c in corridors:
		draw_line(c.start*display_scale, c.end*display_scale, Color.BLACK, 2)
