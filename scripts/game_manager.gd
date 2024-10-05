extends Node

const max_bugs_count: int = 30
const closest_bug_update_time = 0.3

var game_data: GameData
var game_analytic: GameAnalytic

var player: Player
var bugs: Array[DustMite] = []
var closest_bug: DustMite = null
var closest_bug_direction: Vector2 = Vector2.ZERO
var closest_bug_distance: float = INF

var current_bugs_count: int = max_bugs_count
var killed_bugs_count: int = 0

const game_field_size: Vector2 = Vector2(-4096, 4096)

enum GameState {
	RUNNING,
	WON
}

var game_state: GameState = GameState.RUNNING

signal game_state_changed(state: GameState)
signal bugs_count_changed(count: int)
signal killed_bugs_count_changed(count: int)
signal closest_bug_info_changed(direction: Vector2, distance: float)

func _ready():
	_load_game()
	_spawn_bugs()

	var timer = Timer.new()
	timer.wait_time = closest_bug_update_time
	timer.autostart = true
	timer.timeout.connect(_update_closest_bug_direction)
	add_child(timer)

func is_game_running() -> bool:
	return game_state == GameState.RUNNING

func set_player(_player: Player) -> void:
	player = _player
	closest_bug = _get_closest_bug()
	_update_closest_bug_direction()

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

	if current_bugs_count == 0:
		_set_game_state(GameState.WON)
	else:
		closest_bug = _get_closest_bug()

func reset_game() -> void:
	current_bugs_count = max_bugs_count
	killed_bugs_count = 0

	bugs.clear()
	_spawn_bugs()
	closest_bug = _get_closest_bug()

	_set_game_state(GameState.RUNNING)

func _get_closest_bug() -> DustMite:
	var _closest_bug: DustMite = null
	var closest_distance: float = INF

	var player_position := get_player_position()

	for bug in bugs:
		if !bug or bug.is_dead():
			continue
		
		var bug_position := bug.global_position
		var distance := player_position.distance_to(bug_position)

		if distance < closest_distance:
			closest_distance = distance
			_closest_bug = bug

	print("player position: ", player_position)
	print("closest bug position: ", _closest_bug.global_position)
	print("closest distance: ", closest_distance)

	return _closest_bug

func _update_closest_bug_direction() -> void:
	if game_state != GameState.RUNNING:
		return

	var player_position := get_player_position()

	closest_bug_direction = player_position.direction_to(closest_bug.global_position)
	closest_bug_distance = player_position.distance_to(closest_bug.global_position)
	closest_bug_info_changed.emit(closest_bug_direction, closest_bug_distance)

func _set_game_state(state: GameState) -> void:
	game_state = state
	game_state_changed.emit(game_state)

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
