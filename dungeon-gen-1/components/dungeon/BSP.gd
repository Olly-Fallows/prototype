extends Node2D
class_name BSP

@export
var size: Vector2i = Vector2i(100,100)
@export_range(1, 10000)
var room_count: int = 10

@export
var tilemap: TileMapLayer	

class Room:
	var subrooms: Array[Room] = []
	var pos: Vector2i
	var size: Vector2i
	
	static func from(p: Vector2, s: Vector2i) -> Room:
		var r := Room.new()
		r.pos = p
		r.size = s
		return r

var tree: Room = Room.new()

func _ready() -> void:
	# Make tree
	tree.pos = Vector2i()
	tree.size = size
	for a in range(1, room_count):
		var r := tree
		while r.subrooms.size() > 0:
			r = r.subrooms.pick_random()
		var s1: Vector2i
		var s2: Vector2i
		var p1: Vector2i = r.pos
		var p2: Vector2i = r.pos
		if r.size.x >= r.size.y:
			if r.size.x % 2 == 1:
				s1 = r.size-Vector2i(1,0)
				s1.x /= 2
				s2 = s1
			else:
				s1 = r.size
				s1.x /= 2
				s2 = s1-Vector2i(1,0)
			p2.x += s1.x+1
		else:
			if r.size.y % 2 == 1:
				s1 = r.size-Vector2i(0,1)
				s1.y /= 2
				s2 = s1
			else:
				s1 = r.size
				s1.y /= 2
				s2 = s1-Vector2i(0,1)
			p2.y += s1.y+1
		r.subrooms.append(Room.from(p1,s1))
		r.subrooms.append(Room.from(p2,s2))
	
	# Init space
	var space := []
	for x in size.x:
		space.append([])
		for y in size.y:
			space[x].append(0)
	
	# Divide Space
	tree.size = size
	tree.pos = Vector2i()
	var terminals: Array[Room] = traverse_tree(tree)
	
	for r in terminals:
		for x in range(r.pos.x, r.pos.x+r.size.x):
			if x >= space.size():
				break
			for y in range(r.pos.y, r.pos.y+r.size.y):
				if y >= space[0].size():
					break
				space[x][y] = 1
	
	update_tilemap(space)

func traverse_tree(room: Room) -> Array[Room]:
	if room.subrooms.size() == 0:
		return [room]
	var rooms: Array[Room] = []
	for r in room.subrooms:
		rooms.append_array(traverse_tree(r))
	return rooms

func update_tilemap(space: Array) -> void:
	var cells: Array[Vector2i] = []
	for x in range(space.size()):
		for y in range(space[x].size()):
			if space[x][y] == 1:
				cells.append(Vector2i(x,y))
	tilemap.set_cells_terrain_connect(cells, 0, 0)
	
#func spawn_player() -> void:
	#if get_tree().get_first_node_in_group("player") == null:
		#var p = player.instantiate()
		#get_tree().current_scene.add_child(p)
		#p.global_position = tilemap.map_to_local(rooms[0].center)
