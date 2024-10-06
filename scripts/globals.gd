extends Node

func get_random_direction() -> Vector2:
	# get random direction but not zero
	var direction := Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	return direction
