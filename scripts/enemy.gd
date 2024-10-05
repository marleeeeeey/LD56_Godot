extends CharacterBody2D

class_name Enemy

var target: Node2D
var speed = 100


func _process(delta: float) -> void:
	if not target:
		target = Globals.get_closest_node_by_group_name(global_position, "Child")


func _physics_process(delta: float) -> void:
	if not target:
		return

	look_at(target.global_position)
	var diff = target.global_position - global_position
	var direction = diff.normalized()
	velocity = direction * speed

	move_and_slide()
	
