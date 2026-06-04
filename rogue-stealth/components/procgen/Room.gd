extends RefCounted
class_name Room

var position: Vector2i
var dimensions: Vector2i

var subrooms: Array[Room] = []

var space: Space

var populator:RoomPopulator

func to_space() -> Space:
	if space != null:
		return space
	space = Space.from(position, dimensions, 0)
	if populator != null:
		space = populator.populate(space)
	return space

static func from(pos: Vector2i, size: Vector2i) -> Room:
	var r := Room.new()
	r.position = pos
	r.dimensions = size
	return r
