extends Object
class_name DungeonRoom

enum RoomType {
	CIRCLE,
	SQUARE
}

@export
var center: Vector2
@export
var radius: int
@export
var type: RoomType

var connections: Array[DungeonRoom]

static func create(
	_radius: int,
	_type: RoomType
) -> DungeonRoom:
	var r: DungeonRoom = DungeonRoom.new()
	r.radius = _radius
	r.type = _type
	return r
