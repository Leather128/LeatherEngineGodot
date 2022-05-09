extends Node2D

export(String) var save_name = "downscroll"
export(bool) var value = false

export(String) var description = ""

var is_bool = true

onready var checkbox = $Checkbox

func _ready():
	value = Settings.get_data(save_name)
	update_checkbox()
	
func update_checkbox():
	checkbox.stop()
	
	if value:
		checkbox.play("Checked")
	else:
		checkbox.play("Unchecked")

func open_option():
	value = !value
	
	if save_name == "vsync":
		OS.set_use_vsync(value)
	
	if save_name == "memory_leaks":
		if value:
			MemoryLeaker.leak_memory()
		else:
			MemoryLeaker.unleak_memory()
