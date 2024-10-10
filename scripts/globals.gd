extends Node
class_name Globals

static var IS_DEBUG: bool = false


static func create_timer(parent: Node, sec, on_timer_timeout, one_shot: bool = true) -> Timer:
	var timer = Timer.new()
	parent.add_child(timer)
	timer.wait_time = sec
	timer.one_shot = one_shot
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	return timer


static func create_on_parent(parent: Node, global_pos: Vector2, scene: PackedScene) -> Node:
	var new_node: Node = scene.instantiate()
	new_node.global_position = global_pos
	parent.add_child(new_node)
	return new_node


static func create_on_parent_center(parent: Node, scene: PackedScene) -> Node:
	return create_in_global_pos(parent, parent.global_position, scene)


static func create_in_global_pos(parent: Node, global_pos: Vector2, scene: PackedScene) -> Node:
	var new_node: Node = scene.instantiate()
	new_node.global_position = global_pos
	parent.add_child(new_node)
	return new_node


static func add_debug_label(node: Node, text: String, append: bool = false) -> void:
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

	if append:
		label.text += "\n" + text
	else:
		label.text = text


static func apply_transform_2d(point: Vector2, glob_transform: Transform2D) -> Vector2:
	# Basis form apply scaling and skrewing for 2D. But transform action not. Is must be added manually.
	return glob_transform.basis_xform(point) + glob_transform.get_origin()  # <===


static func get_random_point_in_rect(rect: Rect2) -> Vector2:
	var random_x = randf_range(rect.position.x, rect.position.x + rect.size.x)
	var random_y = randf_range(rect.position.y, rect.position.y + rect.size.y)
	return Vector2(random_x, random_y)


static func get_random_point_in_rectangle_shape_2d(rect: RectangleShape2D) -> Vector2:
	var random_x = randf_range(-rect.extents.x, rect.extents.x)
	var random_y = randf_range(-rect.extents.y, rect.extents.y)
	return Vector2(random_x, random_y)


static func get_random_point_in_circle_shape_2d(circle: CircleShape2D) -> Vector2:
	var radius = circle.radius * sqrt(randf())  # sqrt to uniform distribution
	var angle = randf_range(0, PI * 2)
	var random_point = Vector2(cos(angle), sin(angle)) * radius
	return random_point


static func get_random_point_shape_2d(shape: Shape2D, glob_transform: Transform2D) -> Vector2:
	if shape is RectangleShape2D:
		return apply_transform_2d(get_random_point_in_rectangle_shape_2d(shape), glob_transform)

	elif shape is CircleShape2D:
		return apply_transform_2d(get_random_point_in_circle_shape_2d(shape), glob_transform)

	# TODO: Implement other shapes
	# elif shape is CapsuleShape2D:
	# 	pass
	# elif shape is ConvexPolygonShape2D:
	# 	pass

	assert(false, "[get_random_point_in_area] Unsupported shape type: " + str(shape))
	return Vector2.ZERO


static func get_random_point_in_area(area: Area2D) -> Vector2:
	var collision_shapes = area.get_children()
	# Randomly select a collision shape and get a random point in it.
	var random_shape = collision_shapes[randi() % collision_shapes.size()]
	var global_transform: Transform2D = random_shape.get_global_transform()
	var shape: Shape2D = random_shape.shape
	return get_random_point_shape_2d(shape, global_transform)


static func calc_bounding_rect_for_path_2d(path_2d: Path2D) -> Rect2:
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


static func get_closest_node(global_pos: Vector2, nodes: Array[Node]) -> Node:
	var closest_target = null
	var closest_dist = INF
	for body: Node in nodes:
		var dist = global_pos.distance_to(body.global_position)
		if dist < closest_dist:
			closest_target = body
			closest_dist = dist
	return closest_target


static func move_towards(this: Node2D, length: float) -> void:
	this.position += this.transform.x * length
	this.move_and_slide()


static func move_towards_position(this: Node2D, pos: Vector2, speed: float) -> void:
	this.look_at(pos)
	var diff = pos - this.global_position
	move_towards_direction(this, diff, speed)


static func move_towards_direction(this: Node2D, direction: Vector2, speed: float) -> void:
	direction = direction.normalized()
	this.velocity = direction * speed
	this.move_and_slide()


# Interpolation is used if you set rotation_speed not zero.
static func move_towards_direction_with_angle_interpolation(
	this: Node2D, direction: Vector2, speed: float, rotation_speed: float
) -> void:
	var target_angle = this.global_position.angle_to_point(this.global_position + direction)
	this.rotation = lerp_angle(this.rotation, target_angle, rotation_speed)
	move_towards_direction(this, direction, speed)


static func get_random_near_value(value: float, variance: float = 0.25) -> float:
	var rand_value = randf_range(value * (1 - variance / 2), value * (1 + variance / 2))
	return rand_value
