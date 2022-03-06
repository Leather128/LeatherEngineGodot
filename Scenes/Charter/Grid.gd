extends Node2D

export(int) var rows = 16
export(int) var columns = 8

export(int) var grid_size = 40

var selected_x = 0
var selected_y:float = 0.0

onready var charter = $"../"
onready var note_template = $"../Notes/Template"

var note_snap = 16

func _ready():
	$"../Notes".remove_child(note_template)
	
	charter.connect("changed_section", self, "load_section")
	
	load_section()

func load_section():
	for note in $"../Notes".get_children():
		note.free()
	
	for note in charter.song.notes[charter.selected_section].sectionNotes:
		spawn_note(note[1] + 1, time_to_y(note[0] - section_start_time()), time_to_y(note[0] - section_start_time()))
	
func _draw():
	var dark = false
	
	for x in columns + 1:
		dark = !dark
		
		if (x * grid_size) + position.x > 1280:
			break
		if (x * grid_size) + position.x < 0 - grid_size:
			continue
		
		for y in rows:
			draw_box(x,y,dark)
			
			dark = !dark
			
			if (y * grid_size) + position.y > 720:
				break
			if (y * grid_size) + position.y < 0 - grid_size:
				continue
	
	$Line.rect_size.x = (columns + 1) * grid_size

func _process(_delta):
	$Line.rect_position.y = time_to_y(Conductor.songPosition - section_start_time())
	
	var prev_selected_x = selected_x
	var prev_selected_y = selected_y
	
	var mouse_pos = get_global_mouse_position()
	mouse_pos.x -= position.x
	mouse_pos.y -= position.y
	
	selected_x = floor(mouse_pos.x / grid_size)
	selected_y = floor(mouse_pos.y / grid_size)
	
	var cool_grid = grid_size / (note_snap / 16.0)
	
	if Input.is_action_pressed("ui_shift"):
		$Selected.rect_position = Vector2(selected_x * grid_size, mouse_pos.y)
	else:
		$Selected.rect_position = Vector2(selected_x * grid_size, floor(mouse_pos.y / cool_grid) * cool_grid)
	
	if prev_selected_x != selected_x or prev_selected_y != selected_y:
		update()
	
	if Input.is_action_just_pressed("mouse_left"):
		if selected_x >= 0 and selected_x <= columns:
			if selected_y >= 0 and selected_y < rows:
				add_note(selected_x, selected_y)
	
	if Input.is_action_just_pressed("ui_confirm"):
		GameplaySettings.song = charter.song
		Scenes.switch_scene("Gameplay")

func add_note(x, y):
	var mouse_pos = get_global_mouse_position()
	mouse_pos.x -= position.x
	mouse_pos.y -= position.y
	
	for note in $"../Notes".get_children():
		if selected_x * grid_size == note.position.x:
			if mouse_pos.y >= note.position.y and mouse_pos.y <= note.position.y + grid_size:
				for note_object in charter.song.notes[charter.selected_section].sectionNotes:
					if note_object[1] == int(x - 1):
						if int(note_object[0]) == int(y_to_time(note.position.y) + section_start_time()):
							charter.song.notes[charter.selected_section].sectionNotes.erase(note_object)
				
				note.queue_free()
				return
	
	spawn_note(x, y)
	
	var strum_time = y_to_time($Selected.rect_position.y) + section_start_time()
	var note_data = int(x - 1)
	var note_length = 0.0
	
	charter.song.notes[charter.selected_section].sectionNotes.append([strum_time, note_data, note_length])

func spawn_note(x, y, custom_y = null):
	if custom_y == null:
		custom_y = $Selected.rect_position.y
	
	var mouse_pos = get_global_mouse_position()
	mouse_pos.x -= position.x
	mouse_pos.y -= position.y
	
	var new_note = note_template.duplicate()
	new_note.position = Vector2(x * grid_size, custom_y)
	
	var anim_spr = new_note.get_node("AnimatedSprite")
	anim_spr.play(NoteFunctions.dir_to_str(int(x - 1) % 4))
	new_note.scale.x = 40.0 / anim_spr.frames.get_frame(anim_spr.animation, anim_spr.frame).get_width()
	new_note.scale.y = 40.0 / anim_spr.frames.get_frame(anim_spr.animation, anim_spr.frame).get_height()
	
	$"../Notes".add_child(new_note)

func draw_box(x, y, is_dark):
	var cool_color = Color(0.9, 0.9, 0.9)
	
	if is_dark:
		cool_color = Color(0.835, 0.835, 0.835)
	
	draw_rect(Rect2(Vector2(x * grid_size, y * grid_size), Vector2(grid_size, grid_size)), cool_color, true)

func y_to_time(y):
	return range_lerp(y + grid_size, position.y, position.y + (rows * grid_size), 0, 16 * Conductor.timeBetweenSteps)

func time_to_y(time):
	return range_lerp(time - Conductor.timeBetweenSteps, 0, 16 * Conductor.timeBetweenSteps, position.y, position.y + (rows * grid_size))

func section_start_time(section = null):
	if section == null:
		section = charter.selected_section
	
	var coolPos:float = 0.0
	
	var good_bpm = Conductor.bpm
	
	for i in section:
		if "changeBPM" in charter.song.notes[i]:
			if charter.song.notes[i]["changeBPM"] == true:
				good_bpm = charter.song.notes[i]["bpm"]
		
		coolPos += 4 * (1000 * (60 / good_bpm))
	
	return coolPos
