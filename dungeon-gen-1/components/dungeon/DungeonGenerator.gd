extends Node2D
class_name DungeonGenerator

@export
var tilemap: TileMapLayer

@export
var room_count: int
@export
var room_min_radius: int
@export
var room_max_radius: int
@export
var target_size: Vector2
@export
var padding: int = 5

@export
var set_seed: int = 0

var rooms: Array[DungeonRoom] = []

func _ready() -> void:
	if set_seed != 0:
		seed(set_seed)
	generate_dungeon.call_deferred()

func generate_dungeon():
	for a in range(room_count):
		rooms.append(
			DungeonRoom.create(
				randi_range(room_min_radius, room_max_radius),
				randi_range(0, DungeonRoom.RoomType.size()-1)
			)
		)
	for r in rooms:
		r.center = Vector2(
			randf_range(-target_size.x/2, target_size.x/2),
			randf_range(-target_size.y/2, target_size.y/2)
		)
	queue_redraw()
	fix_overlap.call_deferred()
	
func fix_overlap():
	var repeat: bool = false
	for r in rooms:
		var overlapping: bool = false
		var overlap_direction: Vector2 = Vector2()
		for r2 in rooms:
			if r2 == r:
				continue
			var dist = r.center - r2.center
			overlap_direction += dist.normalized()
			if dist.length() <= r.radius + r2.radius + padding:
				overlapping = true
		if overlapping:
			r.center += overlap_direction.normalized()*randf_range(1, rooms.size())
			repeat = true
	queue_redraw()
	if repeat:
		fix_overlap.call_deferred()
	else:
		for r in rooms:
			var closest = null
			var distance: float
			for r2 in rooms:
				if r == r2:
					continue
				if closest == null:
					closest = r2
					distance = (r.center-r2.center).length()
				if distance > (r.center-r2.center).length():
					distance = (r.center-r2.center).length()
					closest = r2
			r.connections.append(closest)
			closest.connections.append(r)
		make_connections.call_deferred()

func map_subgraphs() -> Array:
	var subgroups = []
	for r in rooms:
		var group = 0
		if group >= subgroups.size():
			subgroups.append([r])
			for c in r.connections:
				if not c in subgroups[group]:
					subgroups[group].append(c)
				for c2 in c.connections:
					if c2 != r:
						if not c2 in subgroups[group]:
							subgroups[group].append(c2)
		while true:
			group += 1
			if group >= subgroups.size():
				subgroups.append([r])
			if r in subgroups[group]:
				for c in r.connections:
					if not c in subgroups[group]:
						subgroups[group].append(c)
					for c2 in c.connections:
						if c2 != r:
							if not c2 in subgroups[group]:
								subgroups[group].append(c2)
				break
	while true:
		var to_delete = null
		for g in subgroups:
			if to_delete != null:
				break
			for g2 in subgroups:
				if to_delete != null:
					break
				if g == g2:
					continue
				for r in g:
					for r2 in g2:
						if r == r2:
							to_delete = g2
							for r3 in g2:
								if not r3 in g:
									g.append(r3)
		if to_delete == null:
			break
		subgroups.erase(to_delete)
	return subgroups

func make_connections() -> void:
	var subgroups = map_subgraphs()
	if subgroups.size() <= 1:
		return
	var group_pos: Array[Vector2] = []
	for g in subgroups:
		var center := Vector2()
		for r in g:
			center += r.center
		center /= g.size()
		group_pos.append(center)
	for g in range(subgroups.size()):
		var closest: int = -1
		var distance: float
		for g2 in range(subgroups.size()):
			if g == g2:
				continue
			if closest == -1:
				closest = g2
				distance = (group_pos[g]-group_pos[g2]).length()
				continue
			var d = (group_pos[g]-group_pos[g2]).length()
			if d < distance:
				closest = g2
				distance = d
		var room1: DungeonRoom = subgroups[g][0]
		var room2: DungeonRoom = subgroups[closest][0]
		distance = (room1.center-room2.center).length()
		for r in subgroups[g]:
			for r2 in subgroups[closest]:
				if r == room1:
					if r2 == room2:
						continue
				if distance > (r.center-r2.center).length():
					room1 = r
					room2 = r2
		room1.connections.append(room2)
		room2.connections.append(room1)
	make_connections.call_deferred()
	queue_redraw()
	
func _draw() -> void:
	for r in rooms:
		for c in r.connections:
			draw_line(r.center, c.center, Color.RED, 5)
	for r in rooms:
		match (r.type):
			DungeonRoom.RoomType.CIRCLE:
				draw_circle(r.center, r.radius, Color.CYAN)
			DungeonRoom.RoomType.SQUARE:
				draw_rect(Rect2(r.center-Vector2(r.radius, r.radius), Vector2(r.radius, r.radius)*2), Color.CYAN)
	var cells: Array[Vector2i] = []
	
	for r in rooms:
		for x in range(-r.radius, r.radius):
			for y in range(-r.radius, r.radius):
				if r.type == DungeonRoom.RoomType.CIRCLE:
					if floor(Vector2(x, y).length()) < r.radius:
						cells.append(Vector2i(r.center)+Vector2i(x, y))
				else:
					cells.append(Vector2i(r.center)+Vector2i(x, y))
	
	tilemap.set_cells_terrain_connect(cells, 0, 0)
