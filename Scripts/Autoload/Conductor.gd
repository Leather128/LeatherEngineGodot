extends Node

var songPosition:float = 0.0
var bpm:float = 100.0
var speed:float = 1.0

var timeBetweenBeats:float = ((60 / bpm) * 1000)
var timeBetweenSteps:float = timeBetweenBeats / 4

var curBeat:int = 0
var curStep:int = 0

var safeZoneOffset:float = 166

signal beat_hit
signal step_hit

func _process(_delta):
	var oldBeat = curBeat
	var oldStep = curStep

	curStep = floor(songPosition / timeBetweenSteps)
	curBeat = floor(songPosition / timeBetweenBeats)
	
	if curStep != oldStep and curStep > oldStep and curStep > 0:
		emit_signal("step_hit")
	if curBeat != oldBeat and curBeat > oldBeat and curBeat > 0:
		emit_signal("beat_hit")

func recalculate_values():
	timeBetweenBeats = ((60 / bpm) * 1000)
	timeBetweenSteps = timeBetweenBeats / 4

func change_bpm(new_bpm):
	bpm = new_bpm
	recalculate_values()
