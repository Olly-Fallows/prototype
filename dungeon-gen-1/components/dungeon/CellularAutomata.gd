extends Node2D
class_name CellularAutomata

@export
var size: Vector2i = Vector2i(100,100)
@export
var density: float = 0.5
@export
var iterations: int = 1

@export
var tilemap: TileMapLayer

func _ready() -> void:
	var space: Array = []
	for x in range(size.x):
		space.append([])
		for y in range(size.y):
			if randf() > density:
				space[x].append(1)
			else:
				space[x].append(0)
	
	update_tilemap(space)

func update_tilemap(space: Array) -> void:
	var cells: Array[Vector2i] = []
	for x in range(space.size()):
		for y in range(space[x].size()):
			if space[x][y] == 1:
				cells.append(Vector2i(x,y))
	tilemap.set_cells_terrain_connect(cells, 0, 0)
