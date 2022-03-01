extends Node2D

export(NoteFunctions.NoteDirection) var direction = NoteFunctions.NoteDirection.Left

export(float) var strum_time = 0.0

var strum_y:float = 0.0
var is_player:bool = false

signal note_miss

func _ready():
	play_animation("")

func play_animation(anim, force = true):
	if force or $AnimatedSprite.frame == $AnimatedSprite.animation.length():
		$AnimatedSprite.play(NoteFunctions.dir_to_str(direction).replace("2", "") + anim)

func _process(_delta):
	if is_player and Conductor.songPosition > strum_time + Conductor.safeZoneOffset and !Settings.get_data("bot"):
		$"../../../".bf.play_animation("sing" + NoteFunctions.dir_to_str(direction).to_upper() + "miss", true)
		$"../../../".bf.timer = 0
		$"../../../".misses += 1
		
		if $"../../../".combo >= 10:
			$"../../../".gf.play_animation("sad", true)
		
		$"../../../".combo = 0
		
		AudioHandler.get_node("Voices").volume_db = -500
		
		emit_signal("note_miss")
		queue_free()
	elif !is_player and Conductor.songPosition >= strum_time:
		$"../../../".dad.play_animation("sing" + NoteFunctions.dir_to_str(direction).to_upper(), true)
		$"../../../".dad.timer = 0
		
		if Settings.get_data("opponent_note_glow"):
			get_node("../../Enemy Strums/" + NoteFunctions.dir_to_str(direction).to_lower()).play_animation("confirm", true)
		
		AudioHandler.get_node("Voices").volume_db = 0
		
		queue_free()
	else:
		if Settings.get_data("downscroll"):
			global_position.y = strum_y + (0.45 * (Conductor.songPosition - strum_time) *
			(round(GameplaySettings.scroll_speed * 1000) / 1000))
		else:
			global_position.y = strum_y - (0.45 * (Conductor.songPosition - strum_time) *
			(round(GameplaySettings.scroll_speed * 1000) / 1000))
