extends Resource

class_name GameAnalytic

static var save_version = 1
static var data_path := "user://game_analytic.tres"

@export var current_save_version = 1
@export var play_time: float = 0.0

static func save(data: GameAnalytic):
	data.current_save_version = save_version
	ResourceSaver.save(data, data_path)

static func load() -> GameAnalytic:
	var old_game_analytic: GameAnalytic = ResourceLoader.load(data_path)

	if old_game_analytic == null or old_game_analytic.current_save_version != save_version:
		return GameAnalytic.new()
	else:
		return old_game_analytic

func to_json() -> String:
	var data = {
		"current_save_version": current_save_version,
		"play_time": play_time
	}
	return JSON.stringify(data)
