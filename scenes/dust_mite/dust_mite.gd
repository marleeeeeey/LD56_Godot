extends CharacterBody2D

class_name DustMite

@export var speed := 100
@export var run_away_distance := 100
@export var run_away_safe_distance := 50
@export var trail_scene: PackedScene
@export var fire_scene: PackedScene

@onready var sprite := $Sprite2D
@onready var death_sound := $AudioStreamPlayer2D

enum State {
	IDLE,
	RUN_AWAY,
	DEAD
}
var current_state: State = State.IDLE
const burn_texture := preload("res://assets/images/burn_enemy.png")

func _physics_process(_delta: float) -> void:
	if current_state == State.DEAD:
		return

	_update_state()

	if current_state == State.RUN_AWAY:
		velocity = _get_direction_away_from_player() * speed
		move_and_slide()

	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false

func die():
	current_state = State.DEAD
	sprite.texture = burn_texture
	death_sound.play()
	await death_sound.finished

	var fire: Fire = fire_scene.instantiate()
	fire.position = global_position
	GameManager.add_child(fire)

	queue_free()

func _update_state():
	if current_state == State.RUN_AWAY and _is_safe_distance_from_player():
		current_state = State.IDLE
		$TrailsTimer.stop()
	if current_state == State.IDLE and _is_near_player():
		current_state = State.RUN_AWAY
		$TrailsTimer.start()

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
	trail.global_position = global_position
	trail.rotation = velocity.angle()
	GameManager.add_scene(trail)

func _on_trails_timer_timeout() -> void:
	if current_state == State.RUN_AWAY:
		_spawn_trail()
