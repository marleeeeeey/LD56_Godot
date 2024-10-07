extends CharacterBody2D

class_name BaseBug

const footsteps_texture := preload("res://assets/images/trails.png")

const dust_scene := preload("res://scenes/dust/dust.tscn")

@export var speed := 400
@export var walk_speed := 300
@export var run_away_distance := 450
@export var run_away_safe_distance := 1000
@export var first_super_power_cooldown := 1
@export var super_power_cooldown := 3
@export var trails_cooldown := 0.4
@export var trails_life_time := 10
@export var max_distance_from_player := 2000
@export var random_direction_change_time := 2
@export var bug_color: Color = Color.WHITE

@onready var bug_sprite: BugSprite = %BugSprite

var death_sound_player: AudioStreamPlayer

enum State {
	IDLE,
	WALK,
	RUN_AWAY,
	DEAD
}
var current_state: State = State.WALK
var run_away_time: float = 0.0
var target_direction: Vector2 = Vector2.ZERO

var is_first_super_power: bool = true
var super_power_timer: Timer

var random_direction_change_timer: Timer


func _ready():
	super_power_timer = Timer.new()
	add_child(super_power_timer)
	super_power_timer.wait_time = first_super_power_cooldown
	super_power_timer.timeout.connect(_on_super_power_timer_timeout)

	random_direction_change_timer = Timer.new()
	add_child(random_direction_change_timer)
	random_direction_change_timer.wait_time = random_direction_change_time
	random_direction_change_timer.timeout.connect(_on_random_direction_change_timer_timeout)

	_set_walk_state()

func _physics_process(delta: float) -> void:
	_update_common_state(delta)
	_process_common_logic(delta)

func use_super_power():
	pass

func process_additional_logic(_delta: float):
	pass

func update_additional_state(_delta: float):
	pass

func die():
	current_state = State.DEAD
	bug_sprite.play_animation(BugSprite.BugAnimation.DEATH)

	await bug_sprite.get_animation_player().animation_finished

	var dust = dust_scene.instantiate()
	dust.global_position = global_position
	GameManager.spawn_scene(dust)

	queue_free()

func is_dead() -> bool:
	return current_state == State.DEAD

func is_running_away() -> bool:
	return current_state == State.RUN_AWAY

func _update_common_state(_delta: float):
	if current_state == State.DEAD:
		return

	if current_state == State.RUN_AWAY and _is_safe_distance_from_player():
		_set_walk_state()

	if current_state == State.WALK and _is_near_player():
		_set_run_away_state()
		
	if current_state == State.RUN_AWAY:
		run_away_time += _delta

	update_additional_state(_delta)

func _process_common_logic(delta: float):
	if current_state == State.DEAD:
		return

	if current_state == State.IDLE:
		velocity = Vector2.ZERO

	if current_state == State.WALK:
		velocity = target_direction * walk_speed
		
	if current_state == State.RUN_AWAY:
		run_away_time += delta
		velocity = _get_direction_away_from_player() * speed

	process_additional_logic(delta)
	
	_update_sprite_direction()
	move_and_slide()

func _set_walk_state():
	current_state = State.WALK
	target_direction = Globals.get_random_direction()
	super_power_timer.stop()
	random_direction_change_timer.start()

func _set_run_away_state():
	current_state = State.RUN_AWAY
	super_power_timer.start()
	random_direction_change_timer.stop()

func _is_safe_distance_from_player() -> bool:
	var player_position := GameManager.get_player_position()
	return global_position.distance_to(player_position) > run_away_safe_distance

func _is_near_player() -> bool:
	var player_position := GameManager.get_player_position()
	return global_position.distance_to(player_position) < run_away_distance

func _get_direction_away_from_player() -> Vector2:
	var player_position := GameManager.get_player_position()
	return (global_position - player_position).normalized()

func _get_direction_to_player() -> Vector2:
	var player_position := GameManager.get_player_position()
	return (player_position - global_position).normalized()

func _update_sprite_direction():
	if velocity.x > 0:
		bug_sprite.scale.x = -1
	elif velocity.x < 0:
		bug_sprite.scale.x = 1

func _on_super_power_timer_timeout():
	if is_dead() or !is_running_away():
		return

	if is_first_super_power:
		is_first_super_power = false
		super_power_timer.wait_time = super_power_cooldown
	
	use_super_power()

func is_far_from_player() -> bool:
	var player_position := GameManager.get_player_position()
	return global_position.distance_to(player_position) > max_distance_from_player

func _on_random_direction_change_timer_timeout():
	if is_far_from_player():
		target_direction = _get_direction_to_player()
	else:
		target_direction = Globals.get_random_direction()
