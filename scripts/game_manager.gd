extends Node

var game_data: GameData
var game_analytic: GameAnalytic

var player: Player

func _ready():
	_load_game()
	print(game_analytic.to_json())

func set_player(_player: Player) -> void:
	player = _player

func get_player_position() -> Vector2:
	return player.global_position

func get_distance_to_player(bug: DustMite) -> float:
	var player_position := get_player_position()
	var bug_position := bug.global_position
	return player_position.distance_to(bug_position)

func handle_bug_hit(bug: DustMite) -> void:
	bug.die()

func add_scene(scene: Node) -> void:
	add_child(scene)

func _save_game():
	GameData.save(game_data)
	GameAnalytic.save(game_analytic)

func _load_game():
	game_data = GameData.load()
	game_analytic = GameAnalytic.load()
