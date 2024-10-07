extends BaseBug

class_name PoisonBug

@export var max_evade_time := 2.0

const poison_cloud_texture: Texture = preload("res://assets/images/cloudet.png")
const trails_scene: PackedScene = preload("res://scenes/trail/trail.tscn")

var evade_time := 0.0
var evade_direction := Vector2.ZERO

func process_additional_logic(_delta: float):
	if evade_direction != Vector2.ZERO:
		evade_time += _delta

		velocity = evade_direction * speed


func update_additional_state(_delta: float):
	if evade_time >= max_evade_time:
		evade_time = 0.0
		evade_direction = Vector2.ZERO

func use_super_power():
	var trail: Trail = trails_scene.instantiate()
	trail.position = position
	trail.texture = poison_cloud_texture
	trail.z_index = 10
	trail.max_life_time = 3.0
	trail.fade_start_time = 1.5
	GameManager.spawn_scene(trail)

	evade_direction = velocity.rotated(deg_to_rad(90)).normalized()
	print("evade_direction: ", evade_direction)
	print("velocity: ", velocity)
	print("PoisonBug: use_super_power")
