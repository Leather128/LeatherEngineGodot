extends Node2D

var cool_things = [
	"left",
	"down",
	"up",
	"right"
]

func _process(_delta):
	for cool in cool_things:
		if !Settings.get_data("bot"):
			if Input.is_action_pressed("gameplay_" + cool):
				$"../../".bf.timer = 0.0
			if Input.is_action_just_pressed("gameplay_" + cool):
				get_node(cool).play_animation("press")
				
				var alreadyHit = false
				var time:float = 0
				
				for note in $"../Player Notes".get_children():
					if note.direction == cool_things.find(cool) and (!alreadyHit or note.strum_time == time):
						if note.strum_time > Conductor.songPosition - Conductor.safeZoneOffset and note.strum_time < Conductor.songPosition + Conductor.safeZoneOffset:
							alreadyHit = true
							$"../../".bf.play_animation("sing" + NoteFunctions.dir_to_str(note.direction).to_upper(), true)
							$"../../".combo += 1
							time = note.strum_time
							note.queue_free()
							get_node(cool).play_animation("confirm")
							
							AudioHandler.get_node("Voices").volume_db = 0
			elif !Input.is_action_pressed("gameplay_" + cool):
				get_node(cool).play_animation("static")
		else:
			for note in $"../Player Notes".get_children():
				if note.direction == cool_things.find(cool):
					if note.strum_time <= Conductor.songPosition:
						$"../../".bf.timer = 0.0
						$"../../".bf.play_animation("sing" + NoteFunctions.dir_to_str(note.direction).to_upper(), true)
						note.queue_free()
						get_node(cool).play_animation("confirm")
						
						AudioHandler.get_node("Voices").volume_db = 0
