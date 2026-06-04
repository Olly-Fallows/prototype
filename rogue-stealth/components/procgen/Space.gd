extends RefCounted
class_name Space

var position: Vector2i
var dimensions: Vector2i

var cells: Array

func in_range(x: int, y: int) -> bool:
	if x - position.x < 0:
		return false
	if y - position.y < 0:
		return false
	if x - position.x >= dimensions.x:
		return false
	if y - position.y >= dimensions.y:
		return false
	return true

func get_cell_at(x: int, y: int) -> int:
	if in_range(x,y):
		return cells[x-position.x][y-position.y]
	return -1
	
func set_cell_at(x: int, y: int, v: int) -> void:
	if in_range(x,y):
		cells[x-position.x][y-position.y] = v

func add_blob(x: int, y: int, v: int, s: int = 0) -> void:
	for x2 in range(-s,s+1):
		for y2 in range(-s,s+1):
			set_cell_at(x+x2, y+y2, v)

func is_wall(x: int, y: int, select: int) -> bool:
	for x2 in range(-1,2):
		for y2 in range(-1,2):
			if get_cell_at(x+x2, y+y2) != select:
				return true
	return false

func to_wall_array(select:int = 1) -> Array[Vector2i]:
	var c: Array[Vector2i] = []
	for x in range(cells.size()):
		for y in range(cells[x].size()):
			if cells[x][y] == select:
				if is_wall(x,y,select):
					c.append(Vector2i(x,y))
	return c

func to_floor_array(select: int = 1) -> Array[Vector2i]:
	var c: Array[Vector2i] = []
	for x in range(cells.size()):
		for y in range(cells[x].size()):
			if cells[x][y] == select:
				c.append(Vector2i(x,y))
	return c

static func from(pos: Vector2i, size: Vector2i, value: int) -> Space:
	var s = Space.new()
	s.position = pos
	s.dimensions = size
	for x in size.x:
		s.cells.append([])
		for y in size.y:
			s.cells[x].append(value)
	return s
