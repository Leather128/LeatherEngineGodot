extends "res://Scripts/Notes/Note.gd"

onready var shooting_sound = $Shooting
onready var splash_sound = $SplashImpact
onready var cam_shake = $"Camera Shake"

func _ready():
	if not game.get_node("Shooting"):
		game.add_child(shooting_sound.duplicate())
		game.add_child(splash_sound.duplicate())
		game.add_child(cam_shake.duplicate())

func note_hit():
	game.get_node("Shooting").play()
	game.get_node("Shooting").play_other_shit()
	
	game.get_node("Camera Shake").shake(0.02, 0.27)
	game.dad.play_animation("singRIGHT", true)
