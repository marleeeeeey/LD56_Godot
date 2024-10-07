extends Node

const simple_bug_scene = preload("res://scenes/bugs/simple_bug.tscn")
const evade_bug_scene = preload("res://scenes/bugs/evade_bug.tscn")
const poison_bug_scene = preload("res://scenes/bugs/poison_bug.tscn")

const idle_bug_count: int = 4
const simple_bug_count: int = 15
const evade_bug_count: int = 10
const poison_bug_count: int = 10

const click_boost_multiplier := 0.01

const closest_bug_update_time = 0.3

var game_data: GameData
var game_analytic: GameAnalytic

var player: Player
var lupa_viewport: Viewport
var bugs: Array[BaseBug] = []
var closest_bug: BaseBug = null
var closest_bug_direction: Vector2 = Vector2.ZERO
var closest_bug_distance: float = INF

var killed_bugs_count: int = 0

var click_times = []
var max_click_age = 1.0

const combo_reset_time = 1
var current_combo = 0
var combo_timer: Timer

const game_field_size: Vector2 = Vector2(-4096, 4096)
const lupa_field_size: Vector2 = Vector2(-500, 500)
const lazer_point_safe_distance: float = 100

enum GameState {
	RUNNING,
	WON
}

var game_state: GameState = GameState.RUNNING

signal game_state_changed(state: GameState)
signal bugs_count_changed(count: int)
signal killed_bugs_count_changed(count: int)
signal closest_bug_info_changed(direction: Vector2, distance: float)
signal combo_changed(combo: int)

func _input(event: InputEvent) -> void:
	if !is_game_running() or !player:
		return

	var is_mouse_event = event is InputEventMouseButton
	var is_touch_event = event is InputEventScreenTouch
	var is_left_click = is_mouse_event and event.button_index == MOUSE_BUTTON_LEFT

	if is_left_click:
		click_times.append(Time.get_ticks_msec() / 1000.0)

	var is_mouse_button_pressed = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	if is_mouse_button_pressed or is_touch_event:
		var mouse_pos = player.get_global_mouse_position()
		player.set_target_position(mouse_pos)

		# print("set target position to ", mouse_pos)
		# print("my position is ", player.global_position)
		# print("distance to target is ", player.global_position.distance_to(mouse_pos))
		
		
func _ready():
	# _load_game()

	var timer = Timer.new()
	timer.wait_time = closest_bug_update_time
	timer.autostart = true
	timer.timeout.connect(_update_closest_bug_direction)
	add_child(timer)

	combo_timer = Timer.new()
	combo_timer.one_shot = true
	combo_timer.timeout.connect(_reset_combo)
	add_child(combo_timer)

	
func is_game_running() -> bool:
	return game_state == GameState.RUNNING

func set_player(_player: Player) -> void:
	player = _player
	
func set_lupa_viewport(_lupa_viewport: Viewport) -> void:
	lupa_viewport = _lupa_viewport
	reset_game()

func get_player_position() -> Vector2:
	if !player:
		return Vector2.ZERO
	
	return player.global_position

func get_click_boost() -> float:
	var current_time = Time.get_ticks_msec() / 1000.0
	click_times = click_times.filter(func(t): return current_time - t <= max_click_age)
	var boost_from_click = 1 + click_boost_multiplier * click_times.size()
	return boost_from_click

func get_distance_to_player(bug: BaseBug) -> float:
	var player_position := get_player_position()
	var bug_position := bug.global_position
	return player_position.distance_to(bug_position)

func get_bugs_count() -> int:
	return bugs.size()

func handle_bug_hit(bug: BaseBug) -> void:
	if bug.is_dead():
		return

	bug.die()

	bugs = bugs.filter(func(b): return !b.is_dead())
	killed_bugs_count += 1
	bugs_count_changed.emit(get_bugs_count())
	killed_bugs_count_changed.emit(killed_bugs_count)

	_increase_combo()

	if get_bugs_count() == 0:
		_set_game_state(GameState.WON)
	else:
		closest_bug = _get_closest_bug()

func reset_game() -> void:
	bugs.clear()
	_spawn_bugs()
	closest_bug = _get_closest_bug()
	_reset_combo()
	_set_game_state(GameState.RUNNING)

func _get_closest_bug() -> BaseBug:
	var _closest_bug: BaseBug = null
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

func spawn_scene(scene: Node) -> void:
	lupa_viewport.add_child(scene)

func _save_game():
	GameData.save(game_data)
	GameAnalytic.save(game_analytic)

func _load_game():
	game_data = GameData.load()
	game_analytic = GameAnalytic.load()

func _spawn_bugs() -> void:
	_spawn_idle_bugs()

	for i in range(simple_bug_count):
		_spawn_bug(simple_bug_scene)

	for i in range(evade_bug_count):
		_spawn_bug(evade_bug_scene)

	for i in range(poison_bug_count):
		_spawn_bug(poison_bug_scene)

func _spawn_bug(bug_scene: PackedScene) -> void:
	var bug = bug_scene.instantiate()
	bug.position = _get_bug_random_position()
	bugs.append(bug)
	spawn_scene(bug)

func _spawn_idle_bugs() -> void:
	for i in range(idle_bug_count):
		var bug: BaseBug = simple_bug_scene.instantiate()
		bugs.append(bug)
		bug.position = _get_bug_random_position_inside_lupa()
		spawn_scene(bug)
		bug.walk_speed = 100
		bug.run_away_distance = 0


func _get_bug_random_position() -> Vector2:
	return Vector2(randf_range(game_field_size.x, game_field_size.y), randf_range(game_field_size.x, game_field_size.y))

func _get_bug_random_position_inside_lupa() -> Vector2:
	var random_point = Vector2(randf_range(lupa_field_size.x, lupa_field_size.y), randf_range(lupa_field_size.x, lupa_field_size.y))

	# dont spawn bugs in lazer point
	while abs(random_point.distance_to(Vector2.ZERO)) < lazer_point_safe_distance:
		random_point = Vector2(randf_range(lupa_field_size.x, lupa_field_size.y), randf_range(lupa_field_size.x, lupa_field_size.y))

	return random_point

func _increase_combo() -> void:
	current_combo += 1
	combo_timer.stop()
	combo_timer.start(combo_reset_time)

func _reset_combo() -> void:
	combo_changed.emit(current_combo)
	current_combo = 0
