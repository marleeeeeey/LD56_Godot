extends BaseBug

class_name SimpleBug

func _ready() -> void:
	bug_sprite.set_color(Color(0.3, 0.512, 1))
	super._ready()

func process_additional_logic(_delta: float):
	pass

func update_additional_state(_delta: float):
	pass
