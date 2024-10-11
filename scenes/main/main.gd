extends Node2D

var enemy_spawn_timer: Timer
var enemy_scene: PackedScene = preload("res://scenes/enemy/enemy.tscn")
var child_scene: PackedScene = preload("res://scenes/child/child.tscn")


func _ready() -> void:
	enemy_spawn_timer = Globals.create_timer(self, 0, on_emeny_spawn_timeout)

	# create several children
	for i in range(5):
		var pos = Globals.get_random_point_in_area($ChildSpawnArea2D)
		var child: Child = Globals.create_on_parent(self, pos, child_scene)
		child.set_base_area($ChildSpawnArea2D)


func on_emeny_spawn_timeout() -> void:
	var pos = Globals.get_random_point_in_area($EnemySpawnArea2D)
	var enemy: Enemy = Globals.create_in_global_pos(self, pos, enemy_scene)
	enemy.set_base_area($EnemySpawnArea2D)
	enemy.set_dead_area($EnemyDeadArea2D)
	enemy_spawn_timer.start(Globals.get_random_near_value(1000))
