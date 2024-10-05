extends CanvasLayer

func _ready() -> void:
	GameManager.bugs_count_changed.connect(handle_bugs_count_changed)
	handle_bugs_count_changed(GameManager.current_bugs_count)
	GameManager.killed_bugs_count_changed.connect(handle_killed_bugs_count_changed)
	handle_killed_bugs_count_changed(GameManager.killed_bugs_count)

func handle_bugs_count_changed(count: int) -> void:
	%Total.text = str(count)

func handle_killed_bugs_count_changed(count: int) -> void:
	%Killed.text = str(count)
