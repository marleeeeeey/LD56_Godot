extends CharacterBody2D

class_name BaseBug

const footsteps_texture := preload("res://assets/images/trails.png")

const trail_scene := preload("res://scenes/trail/trail.tscn")
const fire_scene := preload("res://scenes/fire/fire.tscn")
const death_sound := preload("res://assets/sfx/explosion.wav")
const burn_texture := preload("res://assets/images/burn_enemy.png")

@export var speed := 650
@export var run_away_distance := 450
@export var run_away_safe_distance := 800
@export var super_power_cooldown := 3
@export var trails_cooldown := 0.2

@onready var sprite := %Sprite

var death_sound_player: AudioStreamPlayer
var super_power_timer: Timer
var trails_timer: Timer

enum State {
	IDLE,
	RUN_AWAY,
	DEAD
}
var current_state: State = State.IDLE
var run_away_time: float = 0.0
var is_first_super_power: bool = true

func _ready():
	death_sound_player = AudioStreamPlayer.new()
	death_sound_player.stream = death_sound
	add_child(death_sound_player)

	super_power_timer = Timer.new()
	super_power_timer.wait_time = super_power_cooldown
	super_power_timer.autostart = false
	super_power_timer.one_shot = false
	super_power_timer.timeout.connect(_on_super_power_timer_timeout)
	add_child(super_power_timer)

	trails_timer = Timer.new()
	trails_timer.wait_time = trails_cooldown
	trails_timer.autostart = false
	trails_timer.one_shot = false
	trails_timer.timeout.connect(_on_trails_timer_timeout)
	add_child(trails_timer)

func _physics_process(delta: float) -> void:
	_update_common_state(delta)
	_process_common_logic(delta)

func use_super_power():
	pass

func process_logic(_delta: float):
	pass

func update_state(_delta: float):
	pass

func die():
	current_state = State.DEAD
	sprite.texture = burn_texture
	death_sound_player.play()
	await death_sound_player.finished

	var fire: Fire = fire_scene.instantiate()
	fire.position = global_position
	GameManager.spawn_scene(fire)

	queue_free()

func is_dead() -> bool:
	return current_state == State.DEAD

func is_running_away() -> bool:
	return current_state == State.RUN_AWAY

func _update_common_state(_delta: float):
	if current_state == State.DEAD:
		return

	if current_state == State.RUN_AWAY and _is_safe_distance_from_player():
		current_state = State.IDLE
		trails_timer.stop()
		super_power_timer.stop()

	if current_state == State.IDLE and _is_near_player():
		current_state = State.RUN_AWAY
		trails_timer.start()
		super_power_timer.start()

	if current_state == State.RUN_AWAY:
		run_away_time += _delta

	update_state(_delta)

func _process_common_logic(delta: float):
	if current_state == State.DEAD:
		return

	if current_state == State.IDLE:
		velocity = Vector2.ZERO

	if current_state == State.RUN_AWAY:
		run_away_time += delta

	process_logic(delta)
	_update_sprite_direction()

func _is_safe_distance_from_player() -> bool:
	var player_position := GameManager.get_player_position()
	return global_position.distance_to(player_position) > run_away_safe_distance

func _is_near_player() -> bool:
	var player_position := GameManager.get_player_position()
	return global_position.distance_to(player_position) < run_away_distance

func _get_direction_away_from_player() -> Vector2:
	var player_position := GameManager.get_player_position()
	return (global_position - player_position).normalized()

func _spawn_trail():
	var trail = trail_scene.instantiate()
	trail.texture = footsteps_texture
	trail.max_life_time = 60.0
	trail.global_position = global_position
	trail.rotation = velocity.angle()
	GameManager.spawn_scene(trail)

func _on_trails_timer_timeout() -> void:
	if current_state == State.RUN_AWAY:
		_spawn_trail()

func _update_sprite_direction():
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

func _on_super_power_timer_timeout():
	if is_dead():
		return

	use_super_power()
