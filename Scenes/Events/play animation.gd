extends Event

func process_event(argument_1, argument_2):
	get_character_from_argument(argument_2).timer = 0
	get_character_from_argument(argument_2).play_animation(argument_1, true)
