extends CanvasLayer

@export var distance_divider := 10.0

@onready var combo_label: Label = %Combo
@onready var combo_animation: AnimationPlayer = %ComboAnimation

func _ready() -> void:
	GameManager.bugs_count_changed.connect(update_bug_count)
	GameManager.killed_bugs_count_changed.connect(update_killed_bug_count)
	GameManager.closest_bug_info_changed.connect(update_compass_direction)
	GameManager.game_state_changed.connect(update_win_label_visibility)
	GameManager.combo_changed.connect(update_combo)

func update_bug_count(count: int) -> void:
	%Total.text = str(count)

func update_killed_bug_count(count: int) -> void:
	pass
	#%Killed.text = str(count)

func update_compass_direction(direction: Vector2, _distance: float):
	%CompasArrow.rotation = direction.angle()
	
func update_win_label_visibility(game_state: GameManager.GameState) -> void:
	%Win.visible = game_state == GameManager.GameState.WON

func update_combo(combo_count: int):
	if combo_count < 2:
		return

	var combo_text: String

	match combo_count:
		2:
			combo_text = "Double kill!"
		3:
			combo_text = "Triple kill!"
		4:
			combo_text = "Ultra Kill!"
		5:
			combo_text = "Rampage!"

	if combo_text != null:
		combo_label.text = combo_text
		combo_animation.play("combo")
			
func _on_button_pressed() -> void:
	GameManager.reset_game() # Replace with function body.
