extends Node2D

var enemy_location_factory: RandomLocationFactory
var enemy_spawn_timer: Timer
var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")

var child_location_factory: RandomLocationFactory
var child_scene: PackedScene = preload("res://scenes/child.tscn")

@onready var enemies_base_area_2d: Area2D = $EnemiesBaseArea2D
@onready var child_base_area_2d: Area2D = $ChildBaseArea2D


func _ready() -> void:
	enemy_location_factory = $EnemyLocationFactory
	enemy_spawn_timer = Globals.create_timer(1, on_emeny_spawn_timeout, false)
	child_location_factory = $ChildLocationFactory

	# create several children
	for i in range(5):
		var pos = child_location_factory.get_random_location()
		var child: Child = Globals.create_on_parent(self, pos, child_scene)
		child.set_base_area(child_base_area_2d)


func on_emeny_spawn_timeout() -> void:
	var pos = enemy_location_factory.get_random_location()
	var enemy: Enemy = Globals.create_in_global_pos(pos, enemy_scene)
	enemy.set_base_area(enemies_base_area_2d)
