extends BaseBug

class_name PoisonBug

const poison_cloud_texture: Texture = preload("res://assets/images/cloudet.png")
const trails_scene: PackedScene = preload("res://scenes/trail/trail.tscn")

func process_additional_logic(_delta: float):
	pass

func update_additional_state(_delta: float):
	pass

func use_super_power():
	var trail: Trail = trails_scene.instantiate()
	trail.position = position
	trail.texture = poison_cloud_texture
	trail.z_index = 10
	trail.max_life_time = 5
	GameManager.spawn_scene(trail)
	print("PoisonBug: use_super_power")
