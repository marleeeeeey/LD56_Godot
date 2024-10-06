extends Node

@onready var world_camera := %WorldViewport/Camera2D

func _ready():
	var world = %LupaViewport.find_world_2d()
	%WorldViewport.world_2d = world

	GameManager.set_lupa_viewport(%LupaViewport)
	
func _process(delta: float) -> void:
	world_camera.position = GameManager.get_player_position()
