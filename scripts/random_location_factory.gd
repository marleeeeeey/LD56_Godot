extends Node

# Class is used to generate random coordinates from the Path2D setting via parameter
# https://docs.godotengine.org/en/stable/getting_started/first_2d_game/05.the_main_game_scene.html#spawning-mobs
class_name RandomLocationFactory

@export var path_2d : Path2D
var path_follow_2d : PathFollow2D

func _ready() -> void:
	assert(path_2d != null, "[RandomLocationFactory] path_2d is not set!")
	path_follow_2d = PathFollow2D.new()
	path_2d.add_child(path_follow_2d)

func get_random_location() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.position
