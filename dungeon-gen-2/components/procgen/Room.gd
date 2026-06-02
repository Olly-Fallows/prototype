extends RefCounted
class_name Room

var position: Vector2i
var size: Vector2i
var min_padding: float = 0
var max_padding: float = 0

var subrooms: Array[Room]
var corridors: Array[Corridor]

var content: Space

var indivisible: bool = false

func partition(count: int = 2) -> void:
	if subrooms.size() > 0:
		var r = subrooms.pick_random()
		while r.indivisible:
			r = subrooms.pick_random()
		r.partition(count)
		return
	var s: Array[Vector2i] = []
	var p: Array[Vector2i] = []
	if size.x >= size.y:
		var width = size.x
		for c in range(count):
			if c == 0:
				p.append(position)
			else:
				p.append(p[-1])
				p[-1].x += s[-1].x + 1
			if c != count-1:
				@warning_ignore("integer_division")
				s.append(Vector2i(((width-(width%(count-c)))/(count-c)), size.y))
				if c != 0:
					s[-1].x -= 1
				width -= s[-1].x
			else:
				var w = size.x - (count-1)
				for i in s:
					w -= i.x
				s.append(Vector2i(w, size.y))
		for c in range(count):
			subrooms.append(Room.from(p[c], s[c], min_padding, max_padding))
	else:
		var height = size.y
		for c in range(count):
			if c == 0:
				p.append(position)
			else:
				p.append(p[-1])
				p[-1].y += s[-1].y + 1
			if c != count-1:
				@warning_ignore("integer_division")
				s.append(Vector2i(size.x, ((height-(height%(count-c)))/(count-c))))
				if c != 0:
					s[-1].y -= 1
				height -= s[-1].y
			else:
				var h = size.y - (count-1)
				for i in s:
					h -= i.y
				s.append(Vector2i(size.x, h))
		for c in range(count):
			subrooms.append(Room.from(p[c], s[c], min_padding, max_padding))
	
func bsp_walkway() -> void:
	pass
	
func cellular_automata(density: float, iterations: int, toplevel: bool = false, min_room: bool = false) -> void:
	if subrooms.size() > 0:
		for r in subrooms:
			r.cellular_automata(density, iterations, false, min_room)
	else:
		if content == null:
			if min_room:
				content = Space.create_random_space(position, size, density, min_padding)
				content.add(Space.create_uniform_space(position,size, 1, max_padding))
			else:
				content = Space.create_random_space(position, size, density, randf_range(min_padding, max_padding))
	if toplevel:
		to_space(false, 1)
		for i in iterations:
			content.do_ca()

func to_space(clear: bool = false, corridor_size: int = 0) -> Space:
	if clear:
		content = null
	if content != null:
		return content
	if subrooms.size() == 0:
		if content == null:
			return Space.create_uniform_space(position, size, 1, randf_range(min_padding, max_padding))
		return content
	content = Space.create_uniform_space(position, size, 0)
	for c in make_corridors():
		if c != null:
			content.add(c.to_space(clear, corridor_size))
	for r in subrooms:
		if r != null:
			content.add(r.to_space(clear))
	return content

func end_rooms() -> Array[Room]:
	if subrooms.size() == 0:
		return [self]
	else:
		var rooms: Array[Room] = []
		for r in subrooms:
			rooms.append_array(r.end_rooms())
		return rooms

func center() -> Vector2i:
	return position + Vector2i(size/2.0)


func make_corridors(clear: bool = false) -> Array[Corridor]:
	if clear:
		corridors = []
	if subrooms.size() == 0:
		return []
	if corridors.size() > 0:
		return corridors
	for r in subrooms:
		corridors.append_array(r.make_corridors())
	for a in range(subrooms.size()-1):
		var start_options: Array[Room] = subrooms[a].end_rooms()
		var end_options: Array[Room] = subrooms[a+1].end_rooms()
		var start = start_options[0]
		var end = end_options[0]
		for s in start_options:
			for e in end_options:
				if (start.center()-end.center()).length() > (s.center()-e.center()).length():
					start = s
					end = e
		corridors.append(Corridor.from(start, end))
	return corridors

func padded_position() -> Vector2i:
	return position + Vector2i((size*max_padding)/2.0)

func padded_size() -> Vector2i:
	return size * (1-max_padding)

static func from(
	p: Vector2i, 
	s: Vector2i, 
	min_p: float = 0, 
	max_p: float = 0
) -> Room:
	var r := Room.new()
	r.position = p
	r.size = s
	r.min_padding = min_p
	r.max_padding = max_p
	return r
