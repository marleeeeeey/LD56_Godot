extends Node2D

func _ready() -> void:
	Globals.create_timer(5, _on_timer_complete)
	
func _on_timer_complete() -> void:
	queue_free()
