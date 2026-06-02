extends RefCounted
class_name Corridor

var start: Vector2i
var end: Vector2i

var content: Space = null

func to_space(clear: bool = false, s:int = 0) -> Space:
	if clear:
		content = null
	if content == null:
		var pos = Vector2i(min(start.x, end.x)-s, min(start.y, end.y)-s)
		var size = Vector2i(max(start.x, end.x)+s, max(start.y, end.y)+s)
		
		print(pos)
		print(size)
		content = Space.create_uniform_space(pos, size)
		var p = start
		if abs(end.x)-abs(start.x) >= abs(end.y)-abs(start.y):
			while p.y < end.y:
				p.y += 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.y > end.y:
				p.y -= 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.x < end.x:
				p.x += 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.x > end.x:
				p.x -= 1
				add_block(p.x-pos.x,p.y-pos.y, s)
		else:
			while p.x < end.x:
				p.x += 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.x > end.x:
				p.x -= 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.y < end.y:
				p.y += 1
				add_block(p.x-pos.x,p.y-pos.y, s)
			while p.y > end.y:
				p.y -= 1
				add_block(p.x-pos.x,p.y-pos.y, s)
	return content

func add_block(x:int, y:int, s:int=0, v:int=1):
	for x2 in range(-s,s+1):
		for y2 in range(-s,s+1):
			if x+x2 < 0:
				continue
			if y+y2 < 0:
				continue
			if x+x2 >= content.cells.size():
				continue
			if y+y2 >= content.cells[x+x2].size():
				continue
			content.cells[x+x2][y+y2] = v

static func from(s: Room, e: Room) -> Corridor:
	var c := x_aligned_corridor(s,e)
	if c != null:
		return c
	c = y_aligned_corridor(s,e)
	if c != null:
		return c
	c = Corridor.new()
	c.start = s.position + Vector2i(s.size/2.0)
	c.end = e.position + Vector2i(e.size/2.0)
	return c

static func x_aligned_corridor(s: Room, e: Room) -> Corridor:
	var min_x = max(s.padded_position().x, e.padded_position().x)+1
	var max_x = min(s.padded_position().x+s.padded_size().x, e.padded_position().x+e.padded_size().x)-1
	
	if min_x > s.padded_position().x+s.padded_size().x:
		return null
	if min_x > e.padded_position().x+e.padded_size().x:
		return null
		
	if max_x < s.padded_position().x:
		return null
	if max_x < e.padded_position().x:
		return null
	
	var x = randi_range(min_x, max_x)
	
	var c := Corridor.new()
	c.start = Vector2i(x, s.position.y+int(s.size.y/2.0))
	c.end = Vector2i(x, e.position.y+int(e.size.y/2.0))
	return c
	
static func y_aligned_corridor(s: Room, e: Room) -> Corridor:
	var min_y = max(s.padded_position().y, e.padded_position().y)+1
	var max_y = min(s.padded_position().y+s.padded_size().y, e.padded_position().y+e.padded_size().y)-1
	
	if min_y > s.padded_position().y+s.padded_size().y:
		return null
	if min_y > e.padded_position().y+e.padded_size().y:
		return null
		
	if max_y < s.padded_position().y:
		return null
	if max_y < e.padded_position().y:
		return null
	
	var y = randi_range(min_y, max_y)
	
	var c := Corridor.new()
	c.start = Vector2i(s.position.x+int(s.size.x/2.0), y)
	c.end = Vector2i(e.position.x+int(e.size.x/2.0), y)
	return c
