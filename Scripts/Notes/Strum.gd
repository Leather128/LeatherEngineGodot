extends Node

export(NoteFunctions.NoteDirection) var direction = NoteFunctions.NoteDirection.Left

export(bool) var enemy_strum = false

func _ready():
	play_animation("static")

func play_animation(anim, force = true):
	if force or $AnimatedSprite.frame == $AnimatedSprite.animation.length():
		$AnimatedSprite.stop()
		$AnimatedSprite.play(NoteFunctions.dir_to_str(direction).replace("2", "") + " " + anim)


func reset_to_static():
	if (enemy_strum and Settings.get_data("opponent_note_glow")) or (!enemy_strum and Settings.get_data("bot")):
		play_animation("static", true)
