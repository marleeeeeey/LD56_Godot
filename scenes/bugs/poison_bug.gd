extends BaseBug

class_name PoisonBug

const poison_cloud_scene: PackedScene = preload("res://scenes/cloud/cloud.tscn")

func process_logic(_delta: float):
	if !is_running_away():
		return

	var direction = _get_direction_away_from_player()
	velocity = direction * speed

	move_and_slide()

func use_super_power():
	var cloud = poison_cloud_scene.instantiate()
	cloud.position = position
	GameManager.spawn_scene(cloud)
	print("PoisonBug: use_super_power")
