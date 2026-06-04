extends RoomPopulator
class_name RandomWalk

func populate(space: Space) -> Space:
	#for x in range(space.dimensions.x):
		#space.add_blob(x, 0, 1, 1)
		#space.add_blob(x, space.dimensions.y-1, 1, 1)
	#for y in range(space.dimensions.y):
		#space.add_blob(0, y, 1, 1)
		#space.add_blob(space.dimensions.x-1, y, 1, 1)
	
	var pos = Vector2i()
	var pos2 = space.dimensions-Vector2i(1,1)
	var movement_options = [
		Vector2i(-1,0),
		Vector2i(1,0),
		Vector2i(0,-1),
		Vector2i(0,1),
		Vector2i(1,1),
		Vector2i(-1,-1),
		Vector2i(-1,1),
		Vector2i(1,-1),
		Vector2i(1,1)
	]
	while true:
		movement_options[-1] = (Vector2i(((pos2-pos)/(pos2-pos).length()).round()))
		var movement = movement_options.pick_random()
		while not space.in_range((pos + movement).x, (pos + movement).y):
			movement = movement_options.pick_random()
		pos += movement
		pos2 -= movement
		if (pos-pos2).length() < 2:
			break
		if space.in_range(pos.x,pos.y):
			if space.in_range(pos2.x,pos2.y):
				space.add_blob(pos.x, pos.y, 1, 1)
				space.add_blob(pos2.x, pos2.y, 1, 1)
	return space
