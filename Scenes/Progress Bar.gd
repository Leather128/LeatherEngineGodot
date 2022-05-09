extends Node2D

onready var bar = $ProgressBar
onready var text = $Text

onready var tween = $Tween

onready var inst: AudioStreamPlayer = AudioHandler.get_node("Inst")

onready var song = GameplaySettings.song.song
onready var difficulty = GameplaySettings.songDifficulty.to_upper()

func _ready():
	modulate = Color(1,1,1,0)
	visible = true
	
	if inst.stream:
		text.bbcode_text = "[center]" + song + " - " + difficulty + " (" + format_time(inst.get_playback_position() + AudioServer.get_time_since_last_mix()) + " / " + format_time(inst.stream.get_length()) + ")"
		
		if Settings.get_data("bot"):
			text.bbcode_text += " [BOT]"
	
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5 / GameplaySettings.song_multiplier, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, ((Conductor.timeBetweenBeats / 1000.0) * 4) / GameplaySettings.song_multiplier)
	tween.start()

func _process(delta):
	text.bbcode_text = "[center]" + song + " - " + difficulty + " (" + format_time((inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / GameplaySettings.song_multiplier) + " / " + format_time(inst.stream.get_length() / GameplaySettings.song_multiplier) + ")"
	
	if Settings.get_data("bot"):
		text.bbcode_text += " [BOT]"
	
	if Conductor.songPosition >= 0:
		bar.value = (inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / inst.stream.get_length()

func format_time(seconds: float, show_ms: bool = false):
	var time_string: String = str(int(seconds / 60)) + ":"
	var time_string_helper: int = int(seconds) % 60
	
	if time_string_helper < 10:
		time_string += "0"
	
	time_string += str(time_string_helper)
	
	if show_ms:
		time_string += "."
		time_string_helper = int((seconds - int(seconds)) * 100)
		
		if time_string_helper < 10:
			time_string += "0"
		
		time_string += str(time_string_helper)
	
	return time_string
