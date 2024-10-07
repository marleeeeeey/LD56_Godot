extends CanvasLayer

@export var distance_divider := 10.0

@onready var combo_label: Label = %Combo
@onready var combo_animation: AnimationPlayer = %ComboAnimation
@onready var combo_audio_player: AudioStreamPlayer = %ComboAudio

var double_kill_sound: AudioStream = preload("res://assets/sfx/double.wav")
var triple_kill_sound: AudioStream = preload("res://assets/sfx/triple.wav")
var ultra_kill_sound: AudioStream = preload("res://assets/sfx/ultra.wav")
var rampage_sound: AudioStream = preload("res://assets/sfx/rampage.wav")

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
	var combo_sound: AudioStream

	match combo_count:
		2:
			combo_text = "Double kill!"
			combo_sound = double_kill_sound
		3:
			combo_text = "Triple kill!"
			combo_sound = triple_kill_sound
		4:
			combo_text = "Ultra Kill!"
			combo_sound = ultra_kill_sound
		5:
			combo_text = "Rampage!"
			combo_sound = rampage_sound
	
	if combo_text != null:
		if combo_audio_player.playing:
			await combo_audio_player.stream_finished
			
		combo_audio_player.stream = combo_sound
		combo_audio_player.play(1)
		combo_label.text = combo_text
		combo_animation.play("combo")
			
func _on_button_pressed() -> void:
	GameManager.reset_game() # Replace with function body.
