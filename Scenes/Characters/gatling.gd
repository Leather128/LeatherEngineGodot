extends "res://Scripts/Character.gd"

onready var game = $"../"

func _ready():
	if not game.get_node("Camera Shake"):
		game.add_child($"Camera Shake".duplicate())

func play_animation(animation, _force = true, _character:int = 0):
	if name != "_":
		last_anim = animation
		
		if !anim_player:
			anim_player = $AnimationPlayer
			anim_sprite = $AnimatedSprite
		
		anim_player.stop()
		
		if anim_sprite:
			anim_sprite.stop()
		
		if anim_player:
			anim_player.play(animation)
		
		if animation.begins_with("sing"):
			game.get_node("Camera Shake").shake(0.04, 0.04)
			game.get_node("Camera2D").zoom -= Vector2(0.105, 0.105)
			game.health -= 0.0158
