extends CanvasLayer

@export var distance_divider := 10.0

func _ready() -> void:
	GameManager.bugs_count_changed.connect(update_bug_count)
	update_bug_count(GameManager.get_bugs_count())
	GameManager.killed_bugs_count_changed.connect(update_killed_bug_count)
	update_killed_bug_count(GameManager.killed_bugs_count)
	GameManager.closest_bug_info_changed.connect(update_compass_direction)
	update_compass_direction(GameManager.closest_bug_direction, GameManager.closest_bug_distance)
	GameManager.game_state_changed.connect(update_win_label_visibility)
	update_win_label_visibility(GameManager.game_state)

func update_bug_count(count: int) -> void:
	%Total.text = str(count)

func update_killed_bug_count(count: int) -> void:
	%Killed.text = str(count)

func update_compass_direction(direction: Vector2, distance: float):
	%CompasArrow.rotation = direction.angle()
	%Distance.text = str(round(distance / distance_divider)) + " nm"

func update_win_label_visibility(game_state: GameManager.GameState) -> void:
	%Win.visible = game_state == GameManager.GameState.WON


func _on_button_pressed() -> void:
	GameManager.reset_game() # Replace with function body.
