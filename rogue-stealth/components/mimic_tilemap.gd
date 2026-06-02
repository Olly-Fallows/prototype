extends SubViewport

@export
var tilemap: TileMapLayer
var copy: TileMapLayer

var whiteout = preload("res://resources/shader/Whiteout.tres")

func _ready() -> void:
	if tilemap != null:
		tilemap.changed.connect(mimic)
		mimic()
	
func mimic() -> void:
	if copy != null:
		remove_child(copy)
	copy = tilemap.duplicate()
	copy.material = whiteout
	add_child(copy)
