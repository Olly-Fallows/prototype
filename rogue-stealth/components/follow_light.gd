extends PointLight2D

@export
var target: Node2D

func _process(_delta: float) -> void:
	if target != null:
		global_position = target.global_position
