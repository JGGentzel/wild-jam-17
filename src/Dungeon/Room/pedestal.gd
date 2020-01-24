extends Spatial


func open_shrine():
	Events.emit_signal("open_shrine")
	globals.is_playing = false
