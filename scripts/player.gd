extends CharacterBody2D

var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
var speed = 300


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

	var mouse_click_position = event_mouse_button.global_position
	shoot(mouse_click_position)


func shoot(target_position : Vector2):
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = (target_position - global_position).normalized().angle()
	get_tree().root.add_child(bullet)
