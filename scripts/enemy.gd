extends CharacterBody2D

class_name Enemy

var target: Node2D
var speed = 100


func _process(delta: float) -> void:
	target = get_closest_target()


func _physics_process(delta: float) -> void:
	if not target:
		return

	look_at(target.global_position)
	var diff = target.global_position - global_position
	var direction = diff.normalized()
	velocity = direction * speed

	move_and_slide()


func get_closest_target() -> Node2D:
	var closest_target = null
	var closest_dist = INF
	var spider_children = get_tree().get_nodes_in_group("Child")
	for body: Child in spider_children:
		var dist = global_position.distance_to(body.global_position)
		if dist < closest_dist:
			closest_target = body
			closest_dist = dist
	return closest_target
