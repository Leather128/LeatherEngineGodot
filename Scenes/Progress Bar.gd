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
		text.bbcode_text = "[center]" + song + " - " + difficulty + " (" + Globals.format_time(inst.get_playback_position() + AudioServer.get_time_since_last_mix()) + " / " + Globals.format_time(inst.stream.get_length()) + ")"
		
		if Settings.get_data("bot"):
			text.bbcode_text += " [BOT]"
	
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5 / GameplaySettings.song_multiplier, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, ((Conductor.timeBetweenBeats / 1000.0) * 4) / GameplaySettings.song_multiplier)
	tween.start()

func _process(delta):
	text.bbcode_text = "[center]" + song + " - " + difficulty + " (" + Globals.format_time((inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / GameplaySettings.song_multiplier) + " / " + Globals.format_time(inst.stream.get_length() / GameplaySettings.song_multiplier) + ")"
	
	if Settings.get_data("bot"):
		text.bbcode_text += " [BOT]"
	
	if Conductor.songPosition >= 0:
		bar.value = (inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / inst.stream.get_length()
