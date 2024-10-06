extends CharacterBody2D

class_name Player

@export var speed := 300.0
@onready var sun := %Sun

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
