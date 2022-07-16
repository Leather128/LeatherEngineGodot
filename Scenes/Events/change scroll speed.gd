extends Event

var tween = Tween.new()

func _ready():
	add_child(tween)

func process_event(argument_1, argument_2):
	tween.stop_all()
	
	if float(argument_2) <= 0:
		Globals.scroll_speed = float(argument_1) / Globals.song_multiplier
	else:
		tween.interpolate_property(Globals, "scroll_speed", Globals.scroll_speed, float(argument_1) / Globals.song_multiplier, float(argument_2) / Globals.song_multiplier, Tween.TRANS_LINEAR)
		tween.start()
