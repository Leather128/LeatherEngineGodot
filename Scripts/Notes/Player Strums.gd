extends Node2D

export(bool) var is_player = true

var key_count = GameplaySettings.key_count

func _process(_delta):
	if is_player:
		for index in key_count:
			if !Settings.get_data("bot"):
				if Input.is_action_pressed("gameplay_" + str(index)):
					$"../../".bf.timer = 0.0
				if Input.is_action_just_pressed("gameplay_" + str(index)):
					get_child(index).play_animation("press")
					
					var alreadyHit = false
					var time:float = 0
					
					for note in $"../Player Notes".get_children():
						if note.note_data == index and (!alreadyHit or note.strum_time == time):
							if note.strum_time > Conductor.songPosition - Conductor.safeZoneOffset and note.strum_time < Conductor.songPosition + Conductor.safeZoneOffset:
								alreadyHit = true
								$"../../".bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true)
								$"../../".combo += 1
								time = note.strum_time
								note.queue_free()
								get_child(index).play_animation("confirm")
								
								AudioHandler.get_node("Voices").volume_db = 0
				elif !Input.is_action_pressed("gameplay_" + str(index)):
					get_child(index).play_animation("static")
			else:
				for note in $"../Player Notes".get_children():
					if note.note_data == index:
						if note.strum_time <= Conductor.songPosition:
							$"../../".bf.timer = 0.0
							$"../../".bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true)
							note.queue_free()
							get_child(index).play_animation("confirm")
							
							AudioHandler.get_node("Voices").volume_db = 0
