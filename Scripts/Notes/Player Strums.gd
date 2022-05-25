extends Node2D

export(bool) var is_player = true

var key_count = GameplaySettings.key_count

onready var game = $"../../"

export(bool) var disabled = false

onready var player_notes = $"../Player Notes"

func _process(_delta):
	if !disabled:
		if is_player:
			for index in key_count:
				if !Settings.get_data("bot"):
					if Input.is_action_pressed("gameplay_" + str(index)):
						if game.bf:
							game.bf.timer = 0.0
					if Input.is_action_just_pressed("gameplay_" + str(index)):
						get_child(index).play_animation("press")
						
						var time:float = 0
						
						var can_hit:Array = []
						
						var lowest_strum:float = INF
						var hit:Node2D = null
						
						for note in $"../Player Notes".get_children():
							if note.note_data == index and (not "been_hit" in note or !note.been_hit):
								if note.strum_time > Conductor.songPosition - (Conductor.safeZoneOffset * note.hitbox_multiplier) and note.strum_time < Conductor.songPosition + (Conductor.safeZoneOffset * note.hitbox_multiplier):
									can_hit.append(note)
						
						for note in can_hit:
							if note.strum_time - Conductor.songPosition <= lowest_strum:
								lowest_strum = note.strum_time - Conductor.songPosition
								hit = note
						
						if hit != null:
							if not "should_hit" in hit:
								hit.should_hit = true
							
							if "character" in hit:
								if hit.character != 0:
									if game.bf:
										game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(hit.direction).to_upper(), true, hit.character)
								else:
									if game.bf:
										game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(hit.direction).to_upper(), true)
							else:
								if game.bf:
									game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(hit.direction).to_upper(), true)
							
							if hit.should_hit:
								game.combo += 1
							else:
								game.misses += 1
								game.combo = 0
								game.health -= hit.hit_damage
							
							time = hit.strum_time
							
							hit.note_hit()
							
							if !hit.is_sustain:
								hit.queue_free()
							else:
								hit.being_pressed = true
								
								if 'been_hit' in hit:
									hit.been_hit = true
							
							get_child(index).play_animation("confirm")
							
							hit.sustain_length -= Conductor.songPosition - hit.strum_time
							
							if hit.should_hit:
								game.popup_rating(hit.strum_time)
							else:
								game.total_notes += 1
								
								game.score -= 10
								
								game.update_gameplay_text()
								game.update_rating_text()
							
							AudioHandler.get_node("Voices").volume_db = 0
						
						for note in player_notes.get_children():
							if note.note_data == index:
								if note.strum_time == time and note != hit:
									note.note_hit()
									note.queue_free()
					elif Input.is_action_just_released("gameplay_" + str(index)):
						get_child(index).play_animation("static")
						
						for note in player_notes.get_children():
							if note.note_data == index:
								if note.is_sustain and note.sustain_length > Conductor.timeBetweenSteps / 3:
									note.being_pressed = false
				else:
					for note in player_notes.get_children():
						if note.note_data == index:
							if note.strum_time <= Conductor.songPosition and (not "been_hit" in note or !note.been_hit):
								if note.should_hit:
									if game.bf:
										game.bf.timer = 0.0
										
										if "character" in note:
											if note.character != 0:
												game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true, note.character)
											else:
												game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true)
										else:
											game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(note.direction).to_upper(), true)
									
									if !note.being_pressed:
										game.popup_rating(note.strum_time)
										game.combo += 1
										game.health += 0.035
									
									if !note.is_sustain:
										note.note_hit()
										note.queue_free()
									else:
										note.note_hit()
										
										note.sustain_length -= Conductor.songPosition - note.strum_time
										note.being_pressed = true
										
										if 'been_hit' in note:
											note.been_hit = true
									
									get_child(index).play_animation("static")
									get_child(index).play_animation("confirm")
									
									AudioHandler.get_node("Voices").volume_db = 0
								else:
									note.queue_free()
