extends CharacterBody2D

class_name Player

@export var speed := 300.0
@export var boost := 0.1

@onready var sun := %Sun

var target_position := Vector2.ZERO
var click_times = []
var max_click_age = 1.0

func _ready():
	GameManager.set_player(self)

func _input(event):
	var has_mouse_or_touch_input = Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch
	
	if has_mouse_or_touch_input:
		var mouse_pos = get_global_mouse_position()
		print("set target position to ", mouse_pos)
		print("my position is ", global_position)
		print("distance to target is ", global_position.distance_to(mouse_pos))
		target_position = mouse_pos
		click_times.append(Time.get_ticks_msec() / 1000.0)

func _physics_process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec() / 1000.0
	click_times = click_times.filter(func(t): return current_time - t <= max_click_age)
	var boost_from_click = 1 + boost * click_times.size()

	if target_position != Vector2.ZERO:
		# print("target position is ", target_position)
		# print("global position is ", global_position)
		

		if global_position.distance_to(target_position) > 10:
			velocity = (target_position - global_position).normalized() * speed * boost_from_click
		else:
			target_position = Vector2.ZERO
			velocity = Vector2.ZERO
	move_and_slide()
	
func _on_bug_hit(body: Node2D) -> void:
	if body is DustMite:
		GameManager.handle_bug_hit(body)
