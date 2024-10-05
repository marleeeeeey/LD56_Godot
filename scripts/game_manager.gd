extends Node

var fire_scene := preload("res://scenes/fire/fire.tscn")

var game_data: GameData
var game_analytic: GameAnalytic

func _ready():
	_load_game()
	print(game_analytic.to_json())

func _save_game():
	GameData.save(game_data)
	GameAnalytic.save(game_analytic)

func _load_game():
	game_data = GameData.load()
	game_analytic = GameAnalytic.load()

func handle_bug_hit(bug: DustMite) -> void:
	bug.die()
	var fire: Fire = fire_scene.instantiate()
	fire.position = bug.global_position
	add_child(fire)
