extends CharacterBody2D

class_name Player

const trail_scene := preload("res://scenes/trail/trail.tscn")
const lazer_burn_texture := preload("res://assets/images/lazer_burn.png")

@export var speed := 300.0

var target_position := Vector2.ZERO

func _ready():
	GameManager.set_player(self)

func _physics_process(_delta: float) -> void:
	if !GameManager.is_game_running():
		return

	if target_position != Vector2.ZERO:
		# print("target position is ", target_position)
		# print("global position is ", global_position)
	
		if global_position.distance_to(target_position) > 10:
			velocity = (target_position - global_position).normalized() * speed * GameManager.get_click_boost()
		else:
			target_position = Vector2.ZERO
			velocity = Vector2.ZERO
	move_and_slide()

func set_target_position(_target: Vector2) -> void:
	target_position = _target

func _on_bug_hit(body: Node2D) -> void:
	if body is BaseBug:
		GameManager.handle_bug_hit(body)

func spawn_lazer_burn_effect() -> void:
	var trail: Trail = trail_scene.instantiate()
	trail.position = global_position
	trail.texture = lazer_burn_texture
	trail.max_life_time = 10
	GameManager.spawn_scene(trail)
