extends Node2D

class_name Trail

@export var texture: Texture2D
@export var max_life_time := 3.0

@onready var sprite: Sprite2D = $Sprite2D

const update_time = 0.1
var life_time := 0.0

func _ready() -> void:
	sprite.texture = texture
	$Timer.wait_time = life_time
	$Timer.start()

func _on_timer_timeout() -> void:
	life_time += 1
	update_opacity()

	if life_time >= max_life_time:
		queue_free()

func update_opacity():
	sprite.modulate.a = 1.0 - (life_time / max_life_time)
