extends RefCounted
class_name Corridor

var start: Vector2i
var end: Vector2i

static func from(s: Room, e: Room) -> Corridor:
	var c := Corridor.new()
	c.start = s.position + Vector2i(s.size/2.0)
	c.end = e.position + Vector2i(e.size/2.0)
	return c
