extends CharacterBody2D

class_name Child

signal on_catch_by(enemy: Enemy)

var is_catched: bool = false


func _ready() -> void:
	add_to_group("Child")


func catching_by(enemy: Enemy):
	on_catch_by.emit(enemy)
	is_catched = true
