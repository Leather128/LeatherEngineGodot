extends Node

# self explanatory
signal player_note_hit(note, dir, type, character)
signal enemy_note_hit(note, dir, type, character)
# must_hit is basically asking if it's a player side note or not btw
signal note_hit(note, dir, type, character, must_hit)

# called when the player misses a note
signal note_miss(note, dir, type, character)

# called every time an event is setup (not sure if this is useful, but better be safe than sorry)
signal event_setup(event)

# called every time an event is triggered
signal event_processed(event)

# formats time into minutes:seconds
func format_time(seconds: float):
	var time_string: String = str(int(seconds / 60)) + ":"
	var time_string_helper: int = int(seconds) % 60
	
	if time_string_helper < 10:
		time_string += "0"
	
	time_string += str(time_string_helper)
	
	return time_string

func _ready() -> void:
	Discord.init()
