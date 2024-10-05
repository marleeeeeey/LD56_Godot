extends Node

const max_bugs_count: int = 30

var game_data: GameData
var game_analytic: GameAnalytic

var player: Player
var bugs: Array[DustMite] = []

var current_bugs_count: int = max_bugs_count
var killed_bugs_count: int = 0

const game_field_size: Vector2 = Vector2(-4096, 4096)

signal bugs_count_changed(count: int)
signal killed_bugs_count_changed(count: int)
func _ready():
	_load_game()
	_spawn_bugs()
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
	current_bugs_count -= 1
	killed_bugs_count += 1
	bugs_count_changed.emit(current_bugs_count)
	killed_bugs_count_changed.emit(killed_bugs_count)

func get_closest_bug_direction() -> Vector2:
	var closest_bug: DustMite = null
	var closest_distance: float = INF

	var player_position := get_player_position()

	for bug in bugs:
		var bug_position := bug.global_position
		var distance := player_position.distance_to(bug_position)

		if distance < closest_distance:
			closest_distance = distance
			closest_bug = bug

	return closest_bug.global_position.direction_to(player_position)
	

func add_scene(scene: Node) -> void:
	add_child(scene)

func _save_game():
	GameData.save(game_data)
	GameAnalytic.save(game_analytic)

func _load_game():
	game_data = GameData.load()
	game_analytic = GameAnalytic.load()

func _spawn_bugs() -> void:
	# spawn bugs in game field
	for i in range(max_bugs_count):
		var bug = preload("res://scenes/dust_mite/dust_mite.tscn").instantiate()
		bug.position = _get_bug_random_position()
		bugs.append(bug)
		add_child(bug)

func _get_bug_random_position() -> Vector2:
	return Vector2(randf_range(game_field_size.x, game_field_size.y), randf_range(game_field_size.x, game_field_size.y))
