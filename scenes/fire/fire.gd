extends Node2D

class_name Fire

@onready var sprite := $Sprite2D

var burn_time := 0.0
var max_burn_time := 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	burn_time += 1
	update_scale()

	if burn_time >= max_burn_time:
		queue_free()

func update_scale():
	sprite.scale = sprite.scale / burn_time
