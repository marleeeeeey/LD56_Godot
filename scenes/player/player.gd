extends CharacterBody2D

@export var fire_scene: PackedScene

@onready var sun := %Sun

const SPEED = 300.0
var target_position := Vector2.ZERO

func _input(event):
	var has_mouse_or_touch_input = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch
	
	if has_mouse_or_touch_input:
		var mouse_pos = get_global_mouse_position()
		print("set target position to ", mouse_pos)
		print("my position is ", global_position)
		print("distance to target is ", global_position.distance_to(mouse_pos))
		target_position = mouse_pos

func _physics_process(_delta: float) -> void:

	if target_position != Vector2.ZERO:
		# print("target position is ", target_position)
		# print("global position is ", global_position)
		

		if global_position.distance_to(target_position) > 10:
			velocity = (target_position - global_position).normalized() * SPEED
		else:
			target_position = Vector2.ZERO
			velocity = Vector2.ZERO
	move_and_slide()
	
func _on_bug_hit(body: Node2D) -> void:
	if body is DustMite:
		GameManager.handle_bug_hit(body)
