extends Node2D

export(String) var action = "left"
export(int) var selected = 0

var is_bool = false

var waiting_for_input = false

func _ready():
	var binds = Settings.get_data("binds")
	$Text.text = action.to_upper() + ": " + binds[selected]

func open_option():
	waiting_for_input = !waiting_for_input
	
	$"../".can_move = !waiting_for_input

func _input(event):
	if event is InputEventKey and event.pressed and waiting_for_input:
		if event.scancode == KEY_ESCAPE:
			open_option()
		else:
			var binds = Settings.get_data("binds")
			
			if !binds.has(OS.get_scancode_string(event.scancode).to_upper()):
				binds[selected] = OS.get_scancode_string(event.scancode).to_upper()
				
				Settings.set_data("binds", binds)
				
				$Text.text = action.to_upper() + ": " + binds[selected]
				$"../".can_move = true
				
				waiting_for_input = false
				
				Keybinds.setup_Binds()
