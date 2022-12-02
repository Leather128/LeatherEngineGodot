extends Node2D

onready var bar: ProgressBar = $ProgressBar
onready var text: Label = $Text

onready var tween: Tween = $Tween

onready var inst: AudioStreamPlayer = AudioHandler.get_node("Inst")

onready var song: String = Globals.song.song
onready var difficulty: String = Globals.songDifficulty.to_upper()

func _ready() -> void:
	modulate = Color(1,1,1,0)
	visible = true
	
	set_time_text()
	
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.5 / Globals.song_multiplier, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, ((Conductor.timeBetweenBeats / 1000.0) * 4) / Globals.song_multiplier)
	tween.start()

func _process(_delta: float) -> void:
	set_time_text()
	if Conductor.songPosition >= 0: bar.value = (inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / inst.stream.get_length()

func set_time_text() -> void:
	if not inst.stream: return
	
	text.text = song + " - " + difficulty + " (" + Globals.format_time((inst.get_playback_position() + AudioServer.get_time_since_last_mix()) / Globals.song_multiplier) + " / " + Globals.format_time(inst.stream.get_length() / Globals.song_multiplier) + ")"
	if Settings.get_data("bot"): text.text += " [BOT]"
