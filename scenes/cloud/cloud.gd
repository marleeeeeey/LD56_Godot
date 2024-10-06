extends Node2D

class_name Cloud

@onready var sprite := $Sprite2D

var fade_time := 0.0
var max_fade_time := 3.0

func _ready() -> void:
    pass

func _on_timer_timeout() -> void:
    fade_time += 1
    update_opacity()

    if fade_time >= max_fade_time:
        queue_free()

func update_opacity():
    sprite.modulate.a = 1.0 - (fade_time / max_fade_time)