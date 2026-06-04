extends Node2D
class_name Dungeon

@export
var size: Vector2i = Vector2i(10,10)

@export
var tilemap: TileMapLayer

var root: Room

func _ready() -> void:
	root = Room.from(Vector2i(), size)
	root.populator = RandomWalk.new()
	
	var s = root.to_space()
	
	tilemap.set_cells_terrain_connect(s.to_wall_array(), 0, 0)
