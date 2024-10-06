extends CharacterBody2D

class_name Child

signal on_catch_by(enemy: Enemy)

var is_catched: bool = false
var base_area: Area2D  # should be set outside
var drift_direction: Vector2
var drift_timer: Timer
var drift_change_interval: float = 2.0
var speed = 150


func _ready() -> void:
	add_to_group("Child")
	drift_timer = Globals.create_timer(0, on_drift_timer_timeout)


func catching_by(enemy: Enemy):
	on_catch_by.emit(enemy)
	is_catched = true

func set_base_area(area: Area2D):
	base_area = area
	base_area.body_exited.connect(on_child_leave_base_zone)

func _physics_process(delta: float) -> void:
	if not is_catched:
		Globals.move_towards_direction_with_angle_interpolation(self, drift_direction, speed, 0.02)

func on_drift_timer_timeout() -> void:
	print("on_drift_timer_timeout")
	drift_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	drift_timer.start(Globals.get_random_near_value(drift_change_interval))

func on_child_leave_base_zone(child: Child):
	print("on_child_leave_base_zone")
	if child is not Child:
		return

	drift_direction *= -1
