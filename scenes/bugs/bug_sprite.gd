extends Node2D

class_name BugSprite

@onready var head: Sprite2D = %Head
@onready var body: Sprite2D = %Body
@onready var animation_player: AnimationPlayer = %AnimationPlayer

enum BugAnimation {
	RUN,
	DEATH
}

func set_color(color: Color) -> void:
	head.modulate = color
	body.modulate = color

func play_animation(animation: BugAnimation):
	match animation:
		BugAnimation.RUN:
			animation_player.play("run")
		BugAnimation.DEATH:
			animation_player.play("death")

func get_animation_player() -> AnimationPlayer:
	return animation_player
