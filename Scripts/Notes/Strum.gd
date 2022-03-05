extends Node

export(NoteFunctions.NoteDirection) var direction = NoteFunctions.NoteDirection.Left
export(int) var note_data = 0

export(bool) var enemy_strum = false

func _ready():
	play_animation("static")

func play_animation(anim, force = true):
	if force or $AnimatedSprite.frame == $AnimatedSprite.animation.length():
		$AnimatedSprite.stop()
		
		var funny = NoteFunctions.dir_to_str(direction)
		
		if anim == "static":
			funny = funny.replace("2", "")
		
		$AnimatedSprite.play(funny + " " + anim)

func reset_to_static():
	if (enemy_strum and Settings.get_data("opponent_note_glow")) or (!enemy_strum and Settings.get_data("bot")):
		play_animation("static", true)
