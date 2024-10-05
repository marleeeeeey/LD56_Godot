extends CharacterBody2D

class_name DustMite

@onready var sprite := $Sprite2D
@onready var death_sound := $AudioStreamPlayer2D

const burn_texture := preload("res://assets/images/burn_enemy.png")

func _physics_process(_delta: float) -> void:
	pass

func die():
	sprite.texture = burn_texture
	death_sound.play()
	await death_sound.finished
	queue_free()
