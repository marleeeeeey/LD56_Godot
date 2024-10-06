extends BaseBug

class_name SimpleBug

func process_logic(_delta: float):
	if !is_running_away():
		return

	var direction = _get_direction_away_from_player()
	velocity = direction * speed

	move_and_slide()
