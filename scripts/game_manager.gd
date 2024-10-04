extends Node

var game_data: GameData

func _ready():
	_load_game()

func _save_game():
	GameData.save(game_data)

func _load_game():
	game_data = GameData.load()
