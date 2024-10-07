extends BaseBug

class_name EvadeBug

@export var max_evade_time := 3.0
@export var evade_speed := 450
@export var change_direction_time := 1.0

var evade_direction := Vector2.ZERO
var evade_time = 0.0
var last_change_direction_time = 0.0

func _ready() -> void:
	bug_sprite.set_color(Color.RED)
	super._ready()

func process_additional_logic(_delta: float):
	if evade_direction == Vector2.ZERO:
		return

	velocity = evade_direction * evade_speed


func update_additional_state(_delta: float):
	if evade_direction == Vector2.ZERO:
		return

	evade_time += _delta
	last_change_direction_time += _delta

	if last_change_direction_time >= change_direction_time:
		last_change_direction_time = 0.0
		evade_direction = velocity.rotated(_get_random_angle()).normalized()

	if evade_time >= max_evade_time:
		evade_time = 0.0
		evade_direction = Vector2.ZERO

func use_super_power():
	if evade_direction != Vector2.ZERO:
		return

	evade_direction = velocity.rotated(_get_random_angle()).normalized()
	print("EvadeBug: use_super_power")

func _get_random_angle():
	var angles = [deg_to_rad(90), deg_to_rad(-90)]
	return angles[randi_range(0, 1)]
