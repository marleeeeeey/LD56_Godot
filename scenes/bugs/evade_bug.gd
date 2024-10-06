extends BaseBug

class_name EvadeBug

@export var evade_max_time = 3.0
@export var evade_speed = 450

var is_evading = false
var evade_time = 0.0

func process_additional_logic(_delta: float):
	if is_evading:
		var direction = _get_direction_away_from_player()
		velocity = direction * evade_speed


func update_additional_state(_delta: float):
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
