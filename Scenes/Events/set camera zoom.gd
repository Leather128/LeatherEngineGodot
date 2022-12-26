extends Event

func process_event(argument_1, argument_2):
	var new_zoom = 1 + (1 - float(argument_1))
	var new_hud_zoom = float(argument_2)
	
	game.default_camera_zoom = new_zoom
	game.default_hud_zoom = new_hud_zoom
