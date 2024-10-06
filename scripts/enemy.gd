extends CharacterBody2D

# Enemy
# +-- Sprite2D
# +-- Marker2D - is needed for attaching victims.
# +-- Area2D	 - for catching notifications (Enemy listen other bodies entered).
# +-- CollisionShape2D - need this because we want to sent body to on_return_to_base_area callback.
class_name Enemy

@onready var catch_area: Area2D = $Area2D
@onready var connection_point: Marker2D = $Marker2D

var target: Child
var catched_target: Child
var speed = 100
var spawn_pos: Vector2
var base_area: Area2D # should be set outside


func _ready() -> void:
	spawn_pos = global_position
	catch_area.body_entered.connect(on_body_entered)


func _process(delta: float) -> void:
	if catched_target:
		return

	if not target:
		# Retrieve Children which is not catched by other Enemies
		var free_children = get_tree().get_nodes_in_group("Child").filter(
			func(node: Child): return not node.is_catched
		)
		target = Globals.get_closest_node(global_position, free_children)
		if target:
			target.on_catch_by.connect(my_target_catched_by_someone)


func _physics_process(delta: float) -> void:
	if target:
		if target.is_catched:
			target = null  # stop forward to this item because it already catched
		else:
			move_towars(target.global_position, delta)
	else:
		move_towars(spawn_pos, delta)


func move_towars(pos: Vector2, delta: float) -> void:
	look_at(pos)
	var diff = pos - global_position
	var direction = diff.normalized()
	velocity = direction * speed
	move_and_slide()


func on_body_entered(body: Child) -> void:
	if body.is_catched:
		#print("I can't cant this")
		return

	body.catching_by(self)
	body.reparent(self.connection_point)
	body.position = Vector2.ZERO
	target = null
	catched_target = body
	catch_area.body_entered.disconnect(on_body_entered)


func my_target_catched_by_someone(other: Enemy):
	if other == self:
		return

	#print("Someone catch this child. It is not actual for me anymore.")
	target.on_catch_by.disconnect(my_target_catched_by_someone)
	target = null
	
func on_return_to_base_area(other: Enemy):
	if target == null and other == self:
		#print("Return to base area")
		# TODO0: Decrease scope
		queue_free()
	
func set_base_area(area: Area2D):
	base_area = area
	base_area.body_entered.connect(on_return_to_base_area)
