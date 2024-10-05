extends Node

var IS_DEBUG: bool = false


func create_timer(sec, on_timer_timeout, one_shot: bool = true) -> Timer:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = sec
	timer.one_shot = one_shot
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	return timer
