extends CharacterBody2D

@export var bullet_scene: PackedScene

var speed = 300
var click_position_canvas = Vector2.ZERO  # Stores the mouse click position


func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * speed


func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)


func _input(event: InputEvent) -> void:
	# Mouse in viewport (screen) coordinates.
	var event_mouse_button = event as InputEventMouseButton
	if not event_mouse_button:
		return

	if event_mouse_button.button_index != MOUSE_BUTTON_LEFT:
		return

	if not event_mouse_button.pressed:
		return

	click_position_canvas = get_global_mouse_position()
	print("Mouse clicked at: ", click_position_canvas)
	shoot()
	queue_redraw()  # force


func _draw():
	if click_position_canvas != Vector2.ZERO:
		print("Draw line from: ", global_position, " to: ", click_position_canvas)
		draw_line(global_position, click_position_canvas, Color(1, 1, 1), 2)
		draw_circle(click_position_canvas, 5, Color(1, 1, 1))
		draw_circle(global_position, 5, Color(1, 1, 1))


func shoot():
	var bullet = bullet_scene.instantiate()
	owner.add_child(bullet)
	
