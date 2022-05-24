extends "res://Scripts/Notes/Note.gd"

func _ready():
	randomize()
	
	for child in get_children():
		if child.name.begins_with("Slurp"):
			if game.get_node(child.name) == null:
				var funny = child.duplicate()
				game.add_child(funny)

func note_hit():
	var timings = [25, 50, 70, 100]
	
	var ms_dif = (strum_time - Conductor.songPosition) / GameplaySettings.song_multiplier
	
	var rating = 4
	
	for i in len(timings):
		if abs(ms_dif) <= timings[i]:
			rating = i
			break
	
	if Settings.get_data("bot"):
		rating = 0
		ms_dif = 0
	
	match(rating):
		0,1:
			game.health -= 0.035
		2:
			game.health -= 0.015
		3:
			game.health -= 0.005
		4:
			game.health += 0.075
	
	game.health += 0.2
	
	game.get_node("Slurp" + str(round(rand_range(1,5)))).play()
