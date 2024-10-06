extends BaseBug

class_name PoisonBug

const poison_cloud_scene: PackedScene = preload("res://scenes/cloud/cloud.tscn")

func process_additional_logic(_delta: float):
	pass

func update_additional_state(_delta: float):
	pass

func use_super_power():
	var cloud = poison_cloud_scene.instantiate()
	cloud.position = position
	GameManager.spawn_scene(cloud)
	print("PoisonBug: use_super_power")
