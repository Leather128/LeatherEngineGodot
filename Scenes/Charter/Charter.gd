extends Node2D

var song:Dictionary
var selected_section = 0

var playing:bool = false

var bpm_changes = []

signal changed_section

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	AudioHandler.stop_audio("Inst")
	AudioHandler.stop_audio("Voices")
	
	if GameplaySettings.song == null:
		var file = File.new()
		file.open(Paths.song_path(GameplaySettings.songName, GameplaySettings.songDifficulty), File.READ)

		GameplaySettings.song = JSON.parse(file.get_as_text()).result["song"]
	
	song = GameplaySettings.song
	
	Conductor.songPosition = 0
	
	for section in song["notes"]:
		if "changeBPM" in section:
			if section["changeBPM"]:
				bpm_changes.append([section_start_time(song["notes"].find(section)), float(section["bpm"])])
	
	Conductor.change_bpm(float(song["bpm"]), bpm_changes)

func _process(delta):
	var prev_section = selected_section
	
	var changed_sections = false
	
	if Input.is_action_just_pressed("ui_left"):
		selected_section -= 1
		changed_sections = true
	if Input.is_action_just_pressed("ui_right"):
		selected_section += 1
		changed_sections = true
	
	if Input.is_action_just_pressed("ui_space"):
		playing = !playing
		
		if playing:
			AudioHandler.play_audio("Inst", Conductor.songPosition / 1000.0)
			
			if song["needsVoices"]:
				AudioHandler.play_audio("Voices", Conductor.songPosition / 1000.0)
		else:
			AudioHandler.stop_audio("Inst")
			AudioHandler.stop_audio("Voices")
	
	if playing:
		Conductor.songPosition += delta * 1000
		
		if Conductor.songPosition >= section_start_time() + (4 * (1000 * (60 / Conductor.bpm))):
			selected_section += 1
			changed_sections = true
	
	if changed_sections:
		if selected_section < 0:
			selected_section = 0
		if selected_section > len(song.notes):
			song.notes.append({
				"lengthInSteps": 16,
				"bpm": song.bpm,
				"changeBPM": false,
				"mustHitSection": true,
				"sectionNotes": [],
				"altAnim": false
			})
		
		emit_signal("changed_section")
		
		Conductor.songPosition = section_start_time()
		
		AudioHandler.get_node("Inst").seek(Conductor.songPosition / 1000)
		AudioHandler.get_node("Voices").seek(Conductor.songPosition / 1000)

func section_start_time(section = null):
	if section == null:
		section = selected_section
	
	var coolPos:float = 0.0
	
	var good_bpm = song["bpm"]
	
	for i in section:
		if "changeBPM" in song.notes[i]:
			if song.notes[i]["changeBPM"] == true:
				good_bpm = song.notes[i]["bpm"]
		
		coolPos += 4 * (1000 * (60 / good_bpm))
	
	return coolPos

func save_file():
	$FileDialog.popup_centered()

func file_saved(path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_line(to_json({"song": song}))
	file.close()
