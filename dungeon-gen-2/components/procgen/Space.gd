extends RefCounted
class_name Space

var cells: Array = []

var position: Vector2i
var size: Vector2i

func do_ca():
	var new_cells := cells
	for x in range(cells.size()):
		for y in range(cells[x].size()):
			var total := 0
			for x2 in range(-1, 2):
				if x+x2 < 0:
					total -= 1
					continue
				if x+x2 >= cells.size():
					total -= 1
					continue
				for y2 in range(-1, 2):
					if y+y2 < 0:
						total -= 1
						continue
					if y+y2 >= cells[x].size():
						total -= 1
						continue
					if y2 == 0 and x2 == 0:
						continue
					total += cells[x+x2][y+y2]
			if total > 4:
				new_cells[x][y] = 1
			elif total < 4:
				new_cells[x][y] = 0
				
	cells = new_cells

func add(space: Space):
	#if space.position.x < position.x:
		#return
	#if space.position.y < position.y:
		#return
	#if space.position.x + space.size.x > position.x + size.x:
		#return
	#if space.position.y + space.size.y > position.y + size.y:
		#return
	for x in range(space.position.x, space.position.x+space.size.x):
		if x-position.x < 0:
			continue
		if x-position.x > cells.size():
			continue
		for y in range(space.position.y, space.position.y+space.size.y):
			if y-position.y < 0:
				continue
			if y-position.y > cells[x-position.x].size():
				continue
			cells[x-position.x][y-position.y] = space.cells[x-space.position.x][y-space.position.y]

static func create_uniform_space(p: Vector2i, s: Vector2i, v: int=0, padding: float=0) -> Space:
	var space := Space.new()
	space.size = s * (1-padding)
	space.position = p + Vector2i((s - space.size)/2.0)
	for x in space.size.x:
		space.cells.append([])
		for y in space.size.y:
			space.cells[x].append(v)
	return space

static func create_random_space(p: Vector2i, s: Vector2i, d: float) -> Space:
	var space := Space.new()
	space.position = p
	space.size = s
	for x in s.x:
		space.cells.append([])
		for y in s.y:
			if randf() <= d:
				space.cells[x].append(1)
			else:
				space.cells[x].append(0)
	return space
