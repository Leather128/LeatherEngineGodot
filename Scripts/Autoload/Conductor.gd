extends Node

var songPosition:float = 0.0
var bpm:float = 100.0
var speed:float = 1.0

var timeBetweenBeats:float = ((60 / bpm) * 1000)
var timeBetweenSteps:float = timeBetweenBeats / 4

var curBeat:int = 0
var curStep:int = 0

var safeZoneOffset:float = 166

var bpm_changes:Array = []

signal beat_hit
signal step_hit

func _process(_delta):
	var oldBeat = curBeat
	var oldStep = curStep

	curStep = floor(songPosition / timeBetweenSteps)
	curBeat = floor(songPosition / timeBetweenBeats)
	
	if curStep != oldStep and curStep > oldStep:
		emit_signal("step_hit")
	if curBeat != oldBeat and curBeat > oldBeat:
		emit_signal("beat_hit")
	
	for change in bpm_changes:
		if change[0] <= songPosition:
			bpm = change[1]
			recalculate_values()

func recalculate_values():
	timeBetweenBeats = ((60 / bpm) * 1000)
	timeBetweenSteps = timeBetweenBeats / 4

func change_bpm(new_bpm, changes = []):
	if len(changes) == 0:
		changes = [[0,new_bpm]]
	
	bpm_changes = changes
	bpm = new_bpm
	recalculate_values()
