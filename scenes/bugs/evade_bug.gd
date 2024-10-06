extends BaseBug

class_name EvadeBug

@export var evade_max_time = 3.0
@export var evade_speed = 800

var is_evading = false
var evade_time = 0.0

func process_logic(_delta: float):
	if !is_running_away():
		return

	var direction = _get_direction_away_from_player()

	if is_evading:
		velocity = direction * evade_speed
	else:
		velocity = direction * speed

	move_and_slide()

func update_state(_delta: float):
	if !is_evading:
		return

	evade_time += _delta
	if evade_time >= evade_max_time:
		is_evading = false
		evade_time = 0.0

func use_super_power():
	if is_evading:
		return

		# get random direction but not towards the player
	is_evading = true
	print("EvadeBug: use_super_power")
