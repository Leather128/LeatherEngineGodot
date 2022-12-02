extends Node2D

var state: String = "blank"

onready var game: Node2D = $"../"
onready var ui: CanvasLayer = game.get_node("UI")

onready var player_strums: Node2D = game.player_strums
onready var enemy_strums: Node2D = game.enemy_strums

onready var player_notes: Node2D = game.player_notes
onready var enemy_notes: Node2D = game.enemy_notes

onready var player_strum_start: Vector2 = player_strums.position
onready var enemy_strums_start: Vector2 = enemy_strums.position

onready var og_downscroll: bool = Settings.get_data("downscroll")

onready var shaders: Dictionary = {
	"pixel": $Shaders/Pixelate,
	"distort": $Shaders/Distort,
	"blammed": $Shaders/Blammed
}

func _ready() -> void:
	Conductor.connect("beat_hit", self, "beat_hit")
	Conductor.connect("step_hit", self, "step_hit")
	
	for strum in player_strums.get_children():
		strum.start_global_pos = strum.global_position
	for strum in enemy_strums.get_children():
		strum.start_global_pos = strum.global_position

func _process(delta: float) -> void:
	var good_downscroll: bool = og_downscroll
	
	shaders["pixel"].visible = false
	shaders["distort"].visible = false
	shaders["blammed"].visible = false
	
	match(state):
		"blank":
			player_strums.position = player_strum_start + Vector2(0, 720)
			enemy_strums.position = enemy_strums_start + Vector2(0, 720)
		"transition":
			player_strums.position = Globals.glerp(player_strums.position, player_strum_start, 0.09, delta)
			enemy_strums.position = Globals.glerp(enemy_strums.position, enemy_strums_start, 0.09, delta)
		"moving", "moving2":
			for strum in player_strums.get_children():
				strum.global_position.x = fmod(strum.start_global_pos.x + ((Conductor.curStep_f - 192.0) * 25.0), 1280.0 + (154.0 / 2.0))
				
			for strum in enemy_strums.get_children():
				strum.global_position.x = fmod(strum.start_global_pos.x + ((Conductor.curStep_f - 192.0) * 25.0), 1280.0 + (154.0 / 2.0))
			
			shaders["pixel"].visible = true
		"square", "square2":
			var player_positions: Array = []
			
			for strum in player_strums.get_children():
				# bottom = bottom of screen, up = up of screen, etc.
				var side: String = "unknown"
				
				if floor(strum.global_position.x) >= 1280.0 - (100.0):
					side = "right"
				elif floor(strum.global_position.y) <= 100.0:
					side = "top"
				elif floor(strum.global_position.x) <= 100.0:
					side = "left"
				
				if floor(strum.global_position.y) >= 720.0 - (100.0) and side != "left":
					side = "bottom"
				
				match(side):
					"bottom":
						strum.global_position.x -= delta * 100.0
						strum.global_position.y = 720 - 100
					"left":
						strum.global_position.y -= delta * 100.0
						strum.global_position.x = 100
					"top":
						strum.global_position.x += delta * 100.0
						strum.global_position.y = 100
					"right":
						strum.global_position.y += delta * 100.0
						strum.global_position.x = 1280 - 100
				
				player_positions.append([strum.global_position, strum.start_global_pos, side])
			
			for note in player_notes.get_children():
				var base_strum_position: Array = player_positions[note.note_data % len(player_positions)]
				
				var current_strum_position: Vector2 = base_strum_position[0]
				var current_side: String = base_strum_position[2]
				
				note.rotation_degrees = 0
				
				match(current_side):
					"bottom":
						note.downscroll = true
						good_downscroll = true
					"top":
						note.downscroll = false
						good_downscroll = false
					"left":
						note.downscroll = true
						good_downscroll = true
						
						note.global_position.y = current_strum_position.y
						note.global_position.x = current_strum_position.x - ((0.45 * (Conductor.songPosition - note.strum_time) * Globals.scroll_speed))
						
						note.rotation_degrees = 90
						
						if note.being_pressed:
							note.global_position.x = current_strum_position.x
					"right":
						note.downscroll = true
						good_downscroll = true
						
						note.global_position.y = current_strum_position.y
						note.global_position.x = current_strum_position.x + ((0.45 * (Conductor.songPosition - note.strum_time) * Globals.scroll_speed))
						
						note.rotation_degrees = -90
						
						if note.being_pressed:
							note.global_position.x = current_strum_position.x
				
				if note.animated_sprite:
					note.animated_sprite.rotation_degrees = -1.0 * note.rotation_degrees
			
			for strum in enemy_strums.get_children():
				strum.modulate.a = 0
			
			shaders["distort"].visible = true
			shaders["blammed"].visible = true
		"reversed":
			for note in player_notes.get_children():
				note.downscroll = !og_downscroll
				good_downscroll = !og_downscroll
			
			shaders["distort"].visible = true
	
	if good_downscroll:
		game.gameplay_text.rect_position.y = 115
		game.health_bar.position.y = 56
		game.progress_bar.position.y = 698
	else:
		game.gameplay_text.rect_position.y = 682
		game.health_bar.position.y = 623
		game.progress_bar.position.y = 6

func beat_hit() -> void:
	if Conductor.curBeat >= 28 and state == "blank":
		state = "transition"

func step_hit() -> void:
	if Conductor.curStep >= 192 and state == "transition":
		state = "moving"
	
	if Conductor.curStep >= 384 and state == "moving":
		for strum in enemy_strums.get_children():
			strum.modulate.a = 0
		
		for strum in player_strums.get_children():
			strum.global_position = strum.start_global_pos
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "stfu i will eat you"
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		for strum in player_strums.get_children():
			strum.global_position = strum.start_global_pos
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "square"
	
	if Conductor.curStep >= 512 and state == "square":
		for strum in enemy_strums.get_children():
			strum.modulate.a = 1
		
		for strum in player_strums.get_children():
			strum.global_position = strum.start_global_pos
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "moving2"
	
	if Conductor.curStep >= 640 and state == "moving2":
		for strum in player_strums.get_children():
			strum.global_position.x = strum.start_global_pos.x
			
			if og_downscroll:
				strum.global_position.y = 100
			else:
				strum.global_position.y = 620
		
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "reversed"
	
	if Conductor.curStep >= 832 and state == "reversed":
		for strum in enemy_strums.get_children():
			strum.modulate.a = 0
		
		for strum in player_strums.get_children():
			strum.global_position = strum.start_global_pos
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "stfu i will eat you"
		
		yield(get_tree().create_timer(0.1), "timeout")
		
		for strum in player_strums.get_children():
			strum.global_position = strum.start_global_pos
		for strum in enemy_strums.get_children():
			strum.global_position = strum.start_global_pos
		
		state = "square2"
