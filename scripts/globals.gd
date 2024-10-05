extends Node

var IS_DEBUG: bool = false


func create_timer(sec, on_timer_timeout, one_shot: bool = true) -> Timer:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = sec
	timer.one_shot = one_shot
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	return timer

# Parent = self
# scene = preload("...")
func create_with_self_pos(parent: Node, scene: PackedScene) -> Node:
	return create_in_global_pos(parent.global_position, scene)
	
func create_in_global_pos(global_pos: Vector2, scene: PackedScene) -> Node:
	var new_node : Node = scene.instantiate()
	new_node.global_position = global_pos
	get_tree().root.add_child(new_node)
	return new_node
	
	
