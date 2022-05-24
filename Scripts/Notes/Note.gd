extends Node2D

export(NoteFunctions.NoteDirection) var direction = NoteFunctions.NoteDirection.Left
export(int) var note_data = 0

export(float) var strum_time = 0.0

var strum_y:float = 0.0
var is_player:bool = false

var being_pressed:bool = false
var been_hit:bool = false
var is_sustain:bool = false
var sustain_length:float = 0.0
var og_sustain_length:float = 0.0

var time_held: float = 0.0

onready var game = $"../../../"

onready var line = $Line2D

var held_sprites:Dictionary = NoteGlobals.held_sprites

var dir_to_string:String

var character:int = 0

var strum: Node2D

onready var bot = Settings.get_data("bot")
onready var opponent_note_glow = Settings.get_data("opponent_note_glow")
onready var downscroll = Settings.get_data("downscroll")

onready var hitsounds = Settings.get_data("hitsounds")

onready var animated_sprite = $AnimatedSprite

var is_alt:bool = false

# use if multiple textures
export(String) var custom_sus_path

# use if only one texture lmao
export(Texture) var single_held_texture
export(Texture) var single_end_held_texture

# custom properties
export(float) var hit_damage = 0
export(float) var hit_sustain_damage = 0

export(float) var miss_damage = 0.07

export(bool) var should_hit = true
export(bool) var cant_miss = false

export(float) var hitbox_multiplier = 1

func _ready():
	dir_to_string = NoteFunctions.dir_to_str(direction)
	
	play_animation("")
	
	if game.dad:
		dad_anim_player = game.dad.get_node("AnimationPlayer")
	
	if game.bf:
		bf_anim_player = game.bf.get_node("AnimationPlayer")

func set_held_note_sprites():
	if custom_sus_path:
		held_sprites = {}
		
		for texture in NoteGlobals.held_sprites:
			if not texture in held_sprites:
				held_sprites[texture] = []
			
			held_sprites[texture][0] = load(custom_sus_path + texture + " hold0000.png")
			held_sprites[texture][1] = load(custom_sus_path + texture + " hold end0000.png")
	elif single_held_texture and single_end_held_texture:
		held_sprites = {}
		
		for texture in NoteGlobals.held_sprites:
			if not texture in held_sprites:
				held_sprites[texture] = []
			
			held_sprites[texture].push_back(single_held_texture)
			held_sprites[texture].push_back(single_end_held_texture)

func play_animation(anim, force = true):
	if animated_sprite is AnimatedSprite:
		if force or animated_sprite.frame == animated_sprite.animation.length():
			animated_sprite.play(dir_to_string + anim)

onready var player_strums = get_node("../../Player Strums")
onready var enemy_strums = get_node("../../Enemy Strums")

onready var voices = AudioHandler.get_node("Voices")

var dad_anim_player:AnimationPlayer
var bf_anim_player:AnimationPlayer

func _process(delta):
	if strum == null:
		if is_player:
			strum = player_strums.get_child(note_data)
		else:
			strum = enemy_strums.get_child(note_data)
	
	if (is_player and Conductor.songPosition > strum_time + Conductor.safeZoneOffset and !bot) and !being_pressed:
		if should_hit and not cant_miss:
			if game.bf:
				if character != 0:
					game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "miss", true, character)
				else:
					game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "miss", true)
			
				game.bf.timer = 0
			
			game.misses += 1
			game.score -= 10
			game.total_notes += 1
			
			if game.combo >= 10 and game.gf:
				game.gf.play_animation("sad", true)
			
			game.combo = 0
			
			game.health -= miss_damage
			
			voices.volume_db = -500
			
			game.update_gameplay_text()
			
			if Settings.get_data("miss_sounds"):
				AudioHandler.play_audio("Misses/" + str(round(rand_range(1,3))))
			
			note_miss()
		
		queue_free()
	elif (!is_player and Conductor.songPosition >= strum_time) and !being_pressed:
		if should_hit:
			if game.dad:
				if character != 0:
					game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
				else:
					game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
				
				if is_alt and game.dad.has_anim("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "-alt", character):
					if character != 0:
						game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "-alt", true, character)
					else:
						game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "-alt", true)
				
				game.dad.timer = 0
			
			if opponent_note_glow:
				strum.play_animation("static")
				strum.play_animation("confirm")
			
			voices.volume_db = 0
			
			note_hit()
			
			if is_sustain:
				being_pressed = true
			else:
				queue_free()
		else:
			queue_free()
	else:
		if is_sustain:
			if being_pressed:
				animated_sprite.visible = false
				
				sustain_length -= (delta * 1000) * GameplaySettings.song_multiplier
				
				var anim_val = 0.15
				
				if game.dad:
					if Settings.get_data("new_sustain_animations"):
						if !is_player:
							if not "is_group_char" in game.dad:
								if dad_anim_player.current_animation_length < 0.15:
									anim_val = dad_anim_player.current_animation_length
						else:
							if not "is_group_char" in game.bf:
								if bf_anim_player.current_animation_length < 0.15:
									anim_val = bf_anim_player.current_animation_length
				
				if !is_player:
					if opponent_note_glow:
						strum.play_animation("confirm", true)
					
					var good: bool = false
					
					if game.dad:
						if "is_group_char" in game.dad:
							if character <= len(game.dad.get_children()) - 3:
								good = game.dad.get_children()[character].get_node("AnimationPlayer").get_current_animation_position() >= anim_val
						else:
							good = dad_anim_player.get_current_animation_position() >= anim_val
					else:
						good = true
					
					if not Settings.get_data("new_sustain_animations"):
						good = true
					
					if good:
						if game.dad:
							if character != 0:
								game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
							else:
								game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
							
							if is_alt:
								if character != 0:
									game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "-alt", true, character)
								else:
									game.dad.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper() + "-alt", true)
							
							game.dad.timer = 0
						
						voices.volume_db = 0
				else:
					var good: bool = false
					
					if time_held >= 0.15:
						good = true
						time_held = 0
					
					if good or not Settings.get_data("new_sustain_animations"):
						if game.bf:
							if character != 0:
								game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true, character)
							else:
								game.bf.play_animation("sing" + NoteFunctions.dir_to_animstr(direction).to_upper(), true)
						
							game.bf.timer = 0
					
					if good:
						strum.play_animation("static", true)
						
						if should_hit:
							strum.play_animation("confirm", true)
						else:
							strum.play_animation("press", true)
						
						voices.volume_db = 0
						
						if should_hit:
							game.health += 0.02
						else:
							game.health -= hit_sustain_damage
			
			var multiplier = 1
			
			var y_pos = ((sustain_length / 1.5) * GameplaySettings.scroll_speed) / scale.y
			
			if downscroll:
				multiplier = -1
				y_pos -= held_sprites[dir_to_string][1].get_height()
			else:
				y_pos -= held_sprites[dir_to_string][1].get_height()
				
			line.points[1].y = y_pos * multiplier
			
			if sustain_length <= 0:
				queue_free()
			else:
				time_held += delta * GameplaySettings.song_multiplier
				update()
		 
		if is_player:
			strum_y = strum.global_position.y
		else:
			strum_y = strum.global_position.y
		
		modulate.a = strum.modulate.a
		global_position.x = strum.global_position.x
		
		if !being_pressed:
			if downscroll:
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
		
		# the funny thing that controls end note position (and size)
		var rect = Rect2(Vector2(-25,0), Vector2(50,0))
		
		rect.size.y = end_texture.get_height()
		rect.size.x *= line.scale.x
		rect.position.x *= line.scale.x
		rect.position.y = line.points[1].y
		
		var multiplier = 1
		
		if downscroll:
			multiplier = -1
			rect.size.y *= -1
			rect.position.y -= -rect.size.y
		
		if line.points[1].y * multiplier < 0:
			rect.size.y -= abs(line.points[1].y) * multiplier
			
			if multiplier == 1:
				rect.position.y += abs(line.points[1].y)
		
		draw_texture_rect(end_texture, rect, false, line.default_color)
		
		if line.points[1].y * multiplier < 0:
			line.points[1].y = 0

func note_hit():
	if is_player and hitsounds:
		AudioHandler.play_audio("Hitsound")
	
	pass

func note_miss():
	pass
