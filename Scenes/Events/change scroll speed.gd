extends Event

var tween = Tween.new()

func _ready():
	add_child(tween)

func process_event(argument_1, argument_2):
	tween.stop_all()
	
	if float(argument_2) <= 0:
		GameplaySettings.scroll_speed = float(argument_1)
	else:
		tween.interpolate_property(GameplaySettings, "scroll_speed", GameplaySettings.scroll_speed, float(argument_1), float(argument_2), Tween.TRANS_LINEAR)
		tween.start()
