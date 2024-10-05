extends Node

# Class is used to generate random coordinates from the Path2D setting via parameter
# https://docs.godotengine.org/en/stable/getting_started/first_2d_game/05.the_main_game_scene.html#spawning-mobs
class_name RandomLocationFactory

@export var path_2d: Path2D
@export var use_bouding_rect: bool = false
var bounding_rect: Rect2
var path_follow_2d: PathFollow2D


func _ready() -> void:
	assert(path_2d != null, "[RandomLocationFactory] path_2d is not set!")
	path_follow_2d = PathFollow2D.new()
	path_2d.add_child(path_follow_2d)
	bounding_rect = Globals.calc_rect_from_path_2d(path_2d)


func get_random_location() -> Vector2:
	if use_bouding_rect:
		return Globals.get_random_point_in_rect(bounding_rect)

	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
