extends "res://Scripts/Notes/Note.gd"

func _ready():
	if not game.has_node("Parry"):
		game.add_child($Parry.duplicate())

func note_hit():
	game.get_node("Parry").play()
