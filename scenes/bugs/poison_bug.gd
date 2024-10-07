extends BaseBug

class_name PoisonBug

@export var max_evade_time := 2.0

const poison_cloud_texture: Texture = preload("res://assets/images/cloudet.png")
const trails_scene: PackedScene = preload("res://scenes/trail/trail.tscn")

var evade_time := 0.0
var evade_direction := Vector2.ZERO

func _ready() -> void:
	super._ready()
	bug_sprite.set_color(Color(0, 0.855, 0))

func process_additional_logic(_delta: float):
	if evade_direction != Vector2.ZERO:
		velocity = evade_direction * speed


func update_additional_state(_delta: float):
	evade_time += _delta

	if evade_time >= max_evade_time:
		evade_time = 0.0
		evade_direction = Vector2.ZERO

func use_super_power():
	%BombStreamPlayer.play()
	
	var trail: Trail = trails_scene.instantiate()
	trail.position = position
	trail.texture = poison_cloud_texture
	trail.z_index = 10
	trail.max_life_time = 3.0
	trail.fade_start_time = 1.5
	GameManager.spawn_scene(trail)

	var angles = [deg_to_rad(90), deg_to_rad(-90)]
	var random_angle = angles[randi_range(0, 1)]

	evade_direction = velocity.rotated(random_angle).normalized()
	print("PoisonBug: use_super_power")
