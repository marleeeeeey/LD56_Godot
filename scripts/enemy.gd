extends CharacterBody2D

# Enemy
# +-- Sprite2D
# +-- Marker2D - is needed for attaching victims.
# +-- Area2D	 - for catching notifications (Enemy listen other bodies entered: my_target_catched_by_someone).
# +-- CollisionShape2D - need this because we want to sent body to on_return_to_base_area callback.
class_name Enemy

@onready var catch_area: Area2D = $Area2D
@onready var connection_point: Marker2D = $Marker2D

var target: Child
var catched_target: Child
var speed = 50
var target_pos_when_complete_or_died: Vector2
var base_area: Area2D  # should be set outside
var dead_area: Area2D  # should be set outside. Area where they fall down.
var lives = 3


func _ready() -> void:
	catch_area.body_entered.connect(on_body_entered)


func _process(delta: float) -> void:
	if lives <= 0:
		return

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
		if target.is_catched or lives <= 0:
			target = null  # stop forward to this item because it already catched
		else:
			#print("moving to target: ", target.global_position)
			Globals.move_towards_position(self, target.global_position, speed)
	else:
		#print("moving to dead zone: ", target_pos_when_complete_or_died)
		Globals.move_towards_position(self, target_pos_when_complete_or_died, speed)


func on_body_entered(body: Node2D) -> void:
	if body is Child:
		var child: Child = body
		if child.is_catched:
			#print("I can't cant this")
			return

		child.catching_by(self)
		child.reparent(self.connection_point)
		child.position = Vector2.ZERO
		target = null
		catched_target = child
		#catch_area.body_entered.disconnect(on_body_entered)

	if body is Bullet:
		var bullet: Bullet = body
		lives -= 1
		print("lives:", lives)
		if lives == 0:
			target_pos_when_complete_or_died = Globals.get_random_point_in_area(dead_area)
			#print("target pos set to died: ", target_pos_when_complete_or_died)
			target = null
		bullet.queue_free()


func my_target_catched_by_someone(other: Enemy):
	if other == self:
		return

	if target:
		#print("Someone catch this child. It is not actual for me anymore.")
		target.on_catch_by.disconnect(my_target_catched_by_someone)
		target = null


func on_return_to_base_area(other: Enemy):
	if target == null and other == self:
		#print("Return to base area")
		# TODO0: Decrease scope
		queue_free()


func on_enter_to_dead_area(other: Enemy):
	if target == null and other == self:
		print("enter dead area")


func set_base_area(area: Area2D):
	base_area = area
	base_area.body_entered.connect(on_return_to_base_area)
	target_pos_when_complete_or_died = Globals.get_random_point_in_area(base_area)


func set_dead_area(area: Area2D):
	dead_area = area
	dead_area.body_entered.connect(on_enter_to_dead_area)
