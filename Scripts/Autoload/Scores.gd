extends Node

var score_file = File.new()

var song_scores: Dictionary = {}
var week_scores: Dictionary = {}

func _ready():
	if score_file.file_exists("user://Scores.json"):
		score_file.open("user://Scores.json", File.READ)
		
		var data = JSON.parse(score_file.get_as_text()).result
		
		song_scores = data.song_scores
		week_scores = data.week_scores
	
	save_to_file()

func save_to_file():
	score_file.open("user://Scores.json", File.WRITE)
	score_file.store_line(to_json({
		"song_scores": song_scores,
		"week_scores": week_scores
	}))
	
	score_file.close()

func format_song(song, difficulty):
	return song + "_" + difficulty

func set_song_score(song, difficulty, score = 0):
	song_scores[format_song(song, difficulty)] = score
	save_to_file()

func get_song_score(song, difficulty):
	if not format_song(song, difficulty) in song_scores:
		set_song_score(song, difficulty, 0)
	
	return int(song_scores[format_song(song, difficulty)])

func set_week_score(week, difficulty, score = 0):
	week_scores[format_song(week, difficulty)] = score
	save_to_file()

func get_week_score(week, difficulty):
	if not format_song(week, difficulty) in week_scores:
		set_week_score(week, difficulty, 0)
	
	return int(week_scores[format_song(week, difficulty)])

func clear_scores():
	song_scores = {}
	week_scores = {}
	
	save_to_file()
