extends Area2D

class_name Bullet

var speed = 2500
var life_time_sec = 2
var dead_timer: Timer


func _ready() -> void:
	dead_timer = Timer.new()
	add_child(dead_timer)
	dead_timer.wait_time = life_time_sec
	dead_timer.one_shot = true
	dead_timer.start()
	dead_timer.timeout.connect(_on_dead_timer_timeout)
	tree_exited.connect(_on_object_destroyed)


func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.die()
	queue_free()


func _on_dead_timer_timeout() -> void:
	if Globals.IS_DEBUG:
		print("[Bullet._on_dead_timer_timeout()] ", self.name)
	queue_free()

func _on_object_destroyed():
	if Globals.IS_DEBUG:
		print("[Bullet._on_object_destroyed()] ", self.name)
