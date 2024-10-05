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


func create_on_parent(parent: Node, global_pos: Vector2, scene: PackedScene) -> Node:
	var new_node: Node = scene.instantiate()
	new_node.global_position = global_pos
	parent.add_child(new_node)
	return new_node


# Parent = self
# scene = preload("...")
func create_on_parent_center(parent: Node, scene: PackedScene) -> Node:
	return create_in_global_pos(parent.global_position, scene)


func create_in_global_pos(global_pos: Vector2, scene: PackedScene) -> Node:
	var new_node: Node = scene.instantiate()
	new_node.global_position = global_pos
	get_tree().root.add_child(new_node)
	return new_node


func add_debug_label(node: Node, text: String) -> void:
	var debug_label_name = "_debug_label"
	var label = node.get_node_or_null(debug_label_name)

	if not label:
		label = Label.new()
		label.name = debug_label_name

		# Setup font style
		var ls = LabelSettings.new()
		ls.font_color = Color.BLACK
		ls.font_size = 20
		ls.shadow_color = Color.WHITE
		ls.shadow_size = 20
		label.label_settings = ls

		node.add_child(label)

	label.text = text


func get_random_point_in_rect(rect: Rect2) -> Vector2:
	var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return Vector2(random_x, random_y)


func calc_rect_from_path_2d(path_2d: Path2D) -> Rect2:
	if path_2d.curve.get_point_count() == 0:
		return Rect2()

	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF

	for i in range(path_2d.curve.get_point_count()):
		var point = path_2d.curve.get_point_position(i)

		if point.x < min_x:
			min_x = point.x
		if point.y < min_y:
			min_y = point.y
		if point.x > max_x:
			max_x = point.x
		if point.y > max_y:
			max_y = point.y

	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))


func get_closest_node(global_pos: Vector2, nodes: Array[Node]) -> Node:
	var closest_target = null
	var closest_dist = INF
	for body: Node in nodes:
		var dist = global_pos.distance_to(body.global_position)
		if dist < closest_dist:
			closest_target = body
			closest_dist = dist
	return closest_target


func get_closest_node_by_group_name(global_pos: Vector2, group_name: String) -> Node:
	return get_closest_node(global_pos, get_tree().get_nodes_in_group(group_name))
