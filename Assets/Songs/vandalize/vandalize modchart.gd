extends Node

onready var game = $"../"

var follow_chars = true

func _ready():
	Conductor.connect("beat_hit", self, "beat_hit")

func _process(_delta):
	if follow_chars:
		if !game.cam_locked:
			if len(game.songData["notes"]) - 1 >= game.curSection:
				if game.songData["notes"][game.curSection].mustHitSection:
					game.defaultCameraZoom = 1.1
					
					if game.bf.anim_player.current_animation.begins_with("singLEFT"):
						game.bf.camOffset = Vector2(180 - 50, -300)
					elif game.bf.anim_player.current_animation.begins_with("singRIGHT"):
						game.bf.camOffset = Vector2(180 + 50, -300)
					elif game.bf.anim_player.current_animation.begins_with("singDOWN"):
						game.bf.camOffset = Vector2(180, -300 + 50)
					elif game.bf.anim_player.current_animation.begins_with("singUP"):
						game.bf.camOffset = Vector2(180, -300 - 50)
					else:
						game.bf.camOffset = Vector2(180, -300)
				else:
					game.defaultCameraZoom = 0.9
					
					if game.dad.anim_player.current_animation.begins_with("singLEFT"):
						game.dad.camOffset = Vector2(200 - 50, -350)
					elif game.dad.anim_player.current_animation.begins_with("singRIGHT"):
						game.dad.camOffset = Vector2(200 + 50, -350)
					elif game.dad.anim_player.current_animation.begins_with("singDOWN"):
						game.dad.camOffset = Vector2(200, -350 + 50)
					elif game.dad.anim_player.current_animation.begins_with("singUP"):
						game.dad.camOffset = Vector2(200, -350 - 50)
					else:
						game.dad.camOffset = Vector2(200, -350)
				
				if game.songData["notes"][game.curSection]["mustHitSection"]:
					game.camera.position = game.player_point.position + Vector2(-1 * game.bf.camOffset.x, game.bf.camOffset.y) + game.cam_offset
				else:
					game.camera.position = game.dad_point.position + game.dad.camOffset + game.cam_offset

func beat_hit():
	if game.health > 0.1:
		game.health -= 0.015
