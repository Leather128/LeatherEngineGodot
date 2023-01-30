extends Node2D

export(String) var direction: String = 'left'
export(int) var note_data: int = 0

export(bool) var enemy_strum: bool = false

onready var animated_sprite = $AnimatedSprite
onready var start_global_pos: Vector2

func _ready() -> void:
	play_animation("static")

func play_animation(anim, force = true):
	if force or animated_sprite.frame == animated_sprite.animation.length():
		animated_sprite.stop()
		
		var funny = direction
		
		if anim == "static":
			funny = funny.replace("2", "")
		
		animated_sprite.play(funny + " " + anim)

func reset_to_static():
	if (enemy_strum and Settings.get_data("opponent_note_glow")) or (!enemy_strum and Settings.get_data("bot")):
		play_animation("static", true)
