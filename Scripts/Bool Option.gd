extends Node2D

export(String) var save_name = "downscroll"
export(bool) var value = false

var is_bool = true

func _ready():
	value = Settings.get_data(save_name)
	update_checkbox()
	
func update_checkbox():
	$Checkbox.stop()
	
	if value:
		$Checkbox.play("Checked")
	else:
		$Checkbox.play("Unchecked")

func open_option():
	value = !value
	
	if save_name == "vsync":
		OS.set_use_vsync(value)
