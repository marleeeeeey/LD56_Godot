extends Node2D

class_name Trail

@export var texture: Texture2D
@export var max_life_time := 3.0
@export var opacity_multiplier := 1
@export var has_fade_out := true

@onready var sprite: Sprite2D = $Sprite2D

const update_time = 0.1
var life_time := 0.0

func _ready() -> void:
	sprite.texture = texture
	$Timer.wait_time = update_time
	$Timer.start()

func _on_timer_timeout() -> void:
	life_time += update_time
	update_opacity()

	if life_time >= max_life_time:
		queue_free()

func update_opacity():
	if !has_fade_out:
		return

	var progress = life_time / max_life_time
	var opacity = 1.0 - (progress * opacity_multiplier)
	sprite.modulate.a = opacity
