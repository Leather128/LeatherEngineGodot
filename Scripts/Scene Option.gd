extends Node2D

export(String) var scene = "Binds Menu"

export(String) var description = ""

var is_bool = false

func open_option():
	Scenes.switch_scene("Options Menus/" + scene)
