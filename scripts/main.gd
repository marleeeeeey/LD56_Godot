extends Node2D

var enemy_location_factory: RandomLocationFactory
var enemy_spawn_timer: Timer
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")


func _ready() -> void:
	enemy_location_factory = $EnemyLocationFactory
	enemy_spawn_timer = Globals.create_timer(1, on_emeny_spawn_timeout, false)


func on_emeny_spawn_timeout() -> void:
	var pos = enemy_location_factory.get_random_location()
	var enemy: Enemy = Globals.create_in_global_pos(pos, enemy_scene)
	Globals.add_debug_label(enemy, str(enemy.global_position))
