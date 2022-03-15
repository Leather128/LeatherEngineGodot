extends Node2D

export(NoteFunctions.NoteDirection) var direction = NoteFunctions.NoteDirection.Left
export(int) var note_data = 0

export(float) var strum_time = 0.0

var strum_y:float = 0.0
var is_player:bool = false

var being_pressed:bool = false
var is_sustain:bool = false
var sustain_length:float = 0.0

onready var game = $"../../../"

onready var line = $Line2D

var held_sprites = NoteGlobals.held_sprites

var dir_to_string:String

var character:int = 0

signal note_miss

func _ready():
	dir_to_string = NoteFunctions.dir_to_str(direction)
	
	play_animation("")

func play_animation(anim, force = true):
	if force or $AnimatedSprite.frame == $AnimatedSprite.animation.length():
		$AnimatedSprite.play(dir_to_string + anim)

func _process(delta):
	if (is_player and Conductor.songPosition > strum_time + Conductor.safeZoneOffset and !Settings.get_data("bot")) and !being_pressed:
		if character != 0:
			game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "miss", true, character)
		else:
			game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "miss", true)
		
		game.bf.timer = 0
		game.misses += 1
		game.score -= 10
		game.total_notes += 1
		
		if game.combo >= 10:
			game.gf.play_animation("sad", true)
		
		game.combo = 0
		
		game.health -= 0.07
		
		AudioHandler.get_node("Voices").volume_db = -500
		
		game.update_gameplay_text()
		
		emit_signal("note_miss")
		queue_free()
	elif (!is_player and Conductor.songPosition >= strum_time) and !being_pressed:
		if character != 0:
			game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
		else:
			game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
		
		game.dad.timer = 0
		
		if Settings.get_data("opponent_note_glow"):
			get_node("../../Enemy Strums/" + dir_to_string.to_lower()).play_animation("confirm", true)
		
		AudioHandler.get_node("Voices").volume_db = 0
		
		if is_sustain:
			being_pressed = true
		else:
			queue_free()
	else:
		if is_sustain:
			if being_pressed:
				$AnimatedSprite.visible = false
				
				sustain_length -= delta * 1000
				
				var anim_val = 0.15
				
				if !is_player:
					if game.dad.get_node("AnimationPlayer").current_animation_length < 0.15:
						anim_val = game.dad.get_node("AnimationPlayer").current_animation_length
				else:
					if game.bf.get_node("AnimationPlayer").current_animation_length < 0.15:
						anim_val = game.bf.get_node("AnimationPlayer").current_animation_length
				
				if !is_player:
					if Settings.get_data("opponent_note_glow"):
						get_node("../../Enemy Strums/" + dir_to_string.to_lower()).play_animation("confirm", true)
					
					if game.dad.get_node("AnimationPlayer").get_current_animation_position() >= anim_val:
						if character != 0:
							game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
						else:
							game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
						
						game.dad.timer = 0
						
						AudioHandler.get_node("Voices").volume_db = 0
				else:
					if game.bf.get_node("AnimationPlayer").get_current_animation_position() >= anim_val:
						if character != 0:
							game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
						else:
							game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
						
						game.bf.timer = 0
						
						get_node("../../Player Strums/" + dir_to_string.to_lower()).play_animation("confirm", true)
						
						AudioHandler.get_node("Voices").volume_db = 0
						
						game.health += 0.02
			
			var multiplier = 1
			
			var y_pos = (sustain_length / 1.5) * GameplaySettings.scroll_speed
			
			if Settings.get_data("downscroll"):
				multiplier = -1
				y_pos -= held_sprites[dir_to_string][1].get_height()
			else:
				y_pos -= held_sprites[dir_to_string][1].get_height()
				
			line.points[1].y = y_pos * multiplier
			
			if sustain_length <= 0:
				queue_free()
			else:
				update()
		 
		if !being_pressed:
			if Settings.get_data("downscroll"):
				global_position.y = strum_y + (0.45 * (Conductor.songPosition - strum_time) *
				(round(GameplaySettings.scroll_speed * 1000) / 1000))
			else:
				global_position.y = strum_y - (0.45 * (Conductor.songPosition - strum_time) *
				(round(GameplaySettings.scroll_speed * 1000) / 1000))
		else:
			global_position.y = strum_y

func _draw():
	if is_sustain:
		var end_texture = held_sprites[dir_to_string][1]
		
		var rect = Rect2(Vector2(-25,0), Vector2(50,0))
		
		rect.size.y = end_texture.get_height()
		rect.position.y = line.points[1].y
		
		if Settings.get_data("downscroll"):
			rect.size.y *= -1
			rect.position.y -= end_texture.get_height()
		
		var multiplier = 1
		
		if Settings.get_data("downscroll"):
			multiplier = -1
		
		if line.points[1].y * multiplier < 0:
			rect.size.y -= abs(line.points[1].y) * multiplier
			
			if multiplier == 1:
				rect.position.y += abs(line.points[1].y)
		
		draw_texture_rect(end_texture, rect, false, line.default_color)
		
		if line.points[1].y * multiplier < 0:
			line.points[1].y = 0
