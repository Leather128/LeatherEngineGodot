extends Node2D

export(String) var save_name = "array_option"

export(Array) var options = ["option1", "option2", "option3"]

export(String) var description = ""

export(String) var base_name = "Array Option"

var value:String

var is_bool = false

onready var text = $Text

func _ready():
	value = Settings.get_data(save_name)
	text.text = base_name + ": " + value.to_upper()

func open_option():
	var selected = 0
	
	for i in len(options):
		if options[i] == Settings.get_data(save_name):
			selected = i
	
	selected += 1
	
	if selected > len(options) - 1:
		selected = 0
	
	value = options[selected]
	
	Settings.set_data(save_name, options[selected])
	
	text.text = base_name + ": " + value.to_upper()
