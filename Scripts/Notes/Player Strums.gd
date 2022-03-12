extends Node2D

export(bool) var is_player = true

var key_count = GameplaySettings.key_count

onready var game = $"../../"

func _process(_delta):
	if is_player:
		for index in key_count:
			if !Settings.get_data("bot"):
				if Input.is_action_pressed("gameplay_" + str(index)):
					game.bf.timer = 0.0
				if Input.is_action_just_pressed("gameplay_" + str(index)):
					get_child(index).play_animation("press")
					
					var time:float = 0
					
					var can_hit:Array = []
					
					var lowest_strum:float = INF
					var hit:Node2D = null
					
					for note in $"../Player Notes".get_children():
						if note.note_data == index:
							if note.strum_time > Conductor.songPosition - Conductor.safeZoneOffset and note.strum_time < Conductor.songPosition + Conductor.safeZoneOffset:
								can_hit.append(note)
					
					for note in can_hit:
						if note.strum_time - Conductor.songPosition <= lowest_strum:
							lowest_strum = note.strum_time - Conductor.songPosition
							hit = note
					
					if hit != null:
						game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(hit.direction).to_upper(), true)
						game.combo += 1
						time = hit.strum_time
						
						if !hit.is_sustain:
							hit.queue_free()
						else:
							hit.being_pressed = true
						
						get_child(index).play_animation("confirm")
						
						game.popup_rating(hit.strum_time)
						
						AudioHandler.get_node("Voices").volume_db = 0
					
					for note in $"../Player Notes".get_children():
						if note.note_data == index:
							if note.strum_time == time and note != hit:
								note.queue_free()
				elif !Input.is_action_pressed("gameplay_" + str(index)):
					get_child(index).play_animation("static")
					
					for note in $"../Player Notes".get_children():
						if note.note_data == index:
							if note.is_sustain and note.sustain_length > Conductor.timeBetweenSteps / 3:
								note.being_pressed = false
			else:
				for note in $"../Player Notes".get_children():
					if note.note_data == index:
						if note.strum_time <= Conductor.songPosition:
							game.bf.timer = 0.0
							game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true)
							
							if !note.being_pressed:
								game.popup_rating(note.strum_time)
								game.combo += 1
								game.health += 0.035
							
							if !note.is_sustain:
								note.queue_free()
							else:
								note.being_pressed = true
							
							get_child(index).play_animation("confirm")
							
							AudioHandler.get_node("Voices").volume_db = 0
