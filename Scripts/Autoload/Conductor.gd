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

	var lastChange:Array = [0,0,0]
	
	for change in bpm_changes:
		if songPosition >= change[0]:
			lastChange = change
			
			bpm = change[1]
			recalculate_values()
	
	if len(lastChange) < 3:
		lastChange.append(0)
	
	curStep = lastChange[2] + floor((songPosition - lastChange[0]) / timeBetweenSteps)
	curBeat = floor(curStep / 4)
	
	if curStep != oldStep and curStep > oldStep:
		emit_signal("step_hit")
	if curBeat != oldBeat and curBeat > oldBeat:
		emit_signal("beat_hit")

func recalculate_values():
	timeBetweenBeats = ((60 / bpm) * 1000)
	timeBetweenSteps = timeBetweenBeats / 4

func change_bpm(new_bpm, changes = []):
	if len(changes) == 0:
		changes = [[0, new_bpm, 0]]
	
	bpm_changes = changes
	bpm = new_bpm
	recalculate_values()

func map_bpm_changes(songData):
	var changes = []
	
	var cur_bpm:float = songData["bpm"]
	var total_steps:int = 0
	var total_pos:float = 0.0
	
	for section in songData["notes"]:
		if "changeBPM" in section:
			if section["changeBPM"] and section["bpm"] != cur_bpm:
				cur_bpm = section["bpm"]
				
				var change = [total_pos, section["bpm"], total_steps]
				
				changes.append(change)
		
		if not "lengthInSteps" in section:
			section["lengthInSteps"] = 16
		
		var section_length:int = section["lengthInSteps"]
		
		total_steps += section_length
		total_pos += ((60 / cur_bpm) * 1000 / 4) * section_length
	
	return changes
