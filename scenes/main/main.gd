extends Node2D

var enemy_location_factory: RandomLocationFactory
var enemy_spawn_timer: Timer
var enemy_scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")

var child_location_factory: RandomLocationFactory
var child_scene: PackedScene = preload("res://scenes/child/child.tscn")

var debug_aim_spawn_timer : Timer
var debug_aim_scene: PackedScene = preload("res://scenes/debug_object/debug_object.tscn")

@onready var enemies_base_area_2d: Area2D = $EnemiesBaseArea2D
@onready var enemies_dead_area_2d: Area2D = $EnemiesDeadArea2D
@onready var child_base_area_2d: Area2D = $ChildBaseArea2D
@onready var debug_aim_spawn_area_2d: Area2D = $DebugObjectSpawnArea2D


func _ready() -> void:
	debug_aim_spawn_timer = Globals.create_timer(0.1, _on_debug_aim_spawn_timer, false)
	return
	
	enemy_location_factory = $EnemyLocationFactory
	enemy_spawn_timer = Globals.create_timer(0, on_emeny_spawn_timeout)
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
	enemy.set_dead_area(enemies_dead_area_2d)
	enemy_spawn_timer.start(Globals.get_random_near_value(1000))

func _on_debug_aim_spawn_timer() -> void:
	var pos = Globals.get_random_point_in_area(debug_aim_spawn_area_2d)
	Globals.create_on_parent(self, pos, debug_aim_scene)
