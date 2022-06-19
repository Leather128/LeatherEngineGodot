extends Character

var animation_notes: Array = []

func _ready() -> void:
	var file: File = File.new()
	
	file.open("res://Assets/Songs/stress/picospeaker.json", File.READ)
	
	var data: Dictionary = JSON.parse(file.get_as_text()).result.song
	
	for section in data.notes:
		for note in section.sectionNotes:
			animation_notes.append(note)
	
	animation_notes.sort_custom(self, "note_sort")

func _process(_delta: float) -> void:
	while len(animation_notes) > 0 and animation_notes[0][0] <= Conductor.songPosition:
		var shot_direction: int = 1
		
		if animation_notes[0][1] >= 2:
			shot_direction = 3
		
		shot_direction += round(rand_range(0, 1))
		
		play_animation('shoot' + str(shot_direction), true)
		
		animation_notes.pop_front()
	
	if anim_player:
		if anim_player.current_animation == "":
			if last_anim == "idle":
				last_anim = "shoot1"
			
			play_animation(last_anim, true)
			
			anim_player.seek(anim_player.current_animation_length - ((1.0/24.0) * 3), true)
			anim_sprite.frame = anim_sprite.frames.get_frame_count(anim_sprite.animation) - 3

func note_sort(a, b):
	return a[0] < b[0]
