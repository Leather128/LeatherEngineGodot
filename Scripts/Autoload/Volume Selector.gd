extends Node2D

var volume = 0
var muted = false

var timer:float = 1.0

func _ready():
	volume = Settings.get_data("volume")
	muted = Settings.get_data("muted")

func _process(delta):
	timer += delta
	
	if Input.is_action_just_pressed("volume_down"):
		volume -= 5
		
		if volume == -50:
			muted = true
		
		timer = 0
		
		Settings.set_data("volume", volume)
		Settings.set_data("muted", muted)
	if Input.is_action_just_pressed("volume_up"):
		volume += 5
		
		muted = false
		timer = 0
		
		Settings.set_data("volume", volume)
		Settings.set_data("muted", muted)
	if Input.is_action_just_pressed("volume_switch"):
		muted = !muted
		timer = 0
		
		Settings.set_data("muted", muted)
	
	if volume > 0:
		volume = 0
	if volume < -50:
		volume = -50
	
	var volume_percent = (100 + (volume * 2)) / 10
	
	for child in $"CanvasLayer/Volume".get_children():
		if float(child.name) <= volume_percent and !muted:
			child.color = Color(1,1,1,1)
		else:
			child.color = Color(1,1,1,0.7)
	
	if timer < 1:
		$CanvasLayer.offset.y = -60 * timer
	else:
		$CanvasLayer.offset.y = -60
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), muted)
