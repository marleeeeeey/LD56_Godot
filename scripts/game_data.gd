extends Resource

class_name GameData

static var save_version = 1
static var data_path := "user://game_data.tres"

@export var current_save_version = 1

static func save(data: GameData):
	data.current_save_version = save_version
	ResourceSaver.save(data, data_path)

static func load() -> GameData:
	var old_game_data: GameData = ResourceLoader.load(data_path)

	if old_game_data == null or old_game_data.current_save_version != save_version:
		return GameData.new()
	else:
		return old_game_data
