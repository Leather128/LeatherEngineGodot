extends CheckBox

onready var hitsound = $"../../../Hitsound"

var base_volume = 0

func _ready():
	pressed = Settings.get_data("charter_hitsounds")
	update_bs()

func update_bs():
	Settings.set_data("charter_hitsounds", pressed)
	
	if pressed:
		hitsound.volume_db = base_volume
	else:
		hitsound.volume_db = -80

func update_volume(value):
	base_volume = value
	update_bs()
