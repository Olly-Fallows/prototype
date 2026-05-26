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

var tree: Room = Room.new()

func _ready() -> void:
	# Make tree
	for a in range(1, room_count):
		var current_room := tree
		while current_room.subrooms.size() > 0:
			current_room = current_room.subrooms.pick_random()
		current_room.subrooms.append(Room.new())
		current_room.subrooms.append(Room.new())
	
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
	
	space = add_doors(space, tree)
	
	update_tilemap(space)

func traverse_tree(room: Room) -> Array[Room]:
	var terminals: Array[Room] = []
	if room.subrooms.size() > 0:
		var p = room.pos
		var s = room.size
		var offset: Vector2i
		var space: Vector2i
		if s.x >= s.y:
			s.x /= room.subrooms.size()
			s.x -= 1
			offset = Vector2i(1+s.x, 0)
			space = Vector2i(1,0)
		else:
			s.y /= room.subrooms.size()
			s.y -= 1
			offset = Vector2i(0, 1+s.y)
			space = Vector2i(0,1)
		for r in room.subrooms:
			r.pos = p
			r.size = s
			var result = traverse_tree(r)
			if result != null:
				terminals.append_array(result)
			p += offset
			if r == room.subrooms[-1]:
				r.size += space
	else:
		return [room]
	return terminals

func add_doors(space: Array, room: Room) -> Array:
	for r in room.subrooms:
		if r.subrooms.size() > 0:
			for a in range(0, r.subrooms.size()-1):
				if r.subrooms[a].subrooms.size() > 0:
					space = add_doors(space, r)
				elif r.subrooms[a+1].subrooms.size() == 0:
					var p1 = r.subrooms[a].pos + Vector2i(r.subrooms[a].size/2.0)
					var p2 = r.subrooms[a+1].pos + Vector2i(r.subrooms[a+1].size/2.0)
					if p1.x == p2.x:
						var offset = randi_range(0, r.subrooms[a].size.x-2)-((r.subrooms[a].size.x-2)/2.0)
						p1.x += offset
						p2.x += offset
						for b in randi_range(p1.y, p2.y):
							space[p1.x][b] = 1
					if p1.y == p2.y:
						var offset = randi_range(0, r.subrooms[a].size.y-2)-((r.subrooms[a].size.y-2)/2.0)
						p1.y += offset
						p2.y += offset
						for b in randi_range(p1.x, p2.x):
							space[b][p1.y] = 1
	return space

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
