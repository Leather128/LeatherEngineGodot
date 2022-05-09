extends Node2D

onready var text = $Text

var intro_texts = []

var random_text:int

onready var enter_text = $"../Enter Text"

func _ready():
	if Scenes.startup:
		randomize()
		
		var file = File.new()
		file.open("res://Assets/intro_text.txt", File.READ)
		intro_texts = file.get_as_text().split("\n")
		
		random_text = floor(rand_range(0, len(intro_texts)))
		
		Conductor.connect("beat_hit", self, "beat_hit")
		
		enter_text.stop_shit = true
	else:
		queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		intro()

func beat_hit():
	match(Conductor.curBeat):
		1:
			text.text = "leather128"
		3:
			text.text += "\npresents"
		4:
			text.text = ""
		5:
			text.text = "In association\nwith"
		7:
			text.text += "\ngodot"
		8:
			text.text = ""
		9:
			text.text = intro_texts[random_text].split("--")[0]
		11:
			text.text += "\n" + intro_texts[random_text].split("--")[1]
		12:
			text.text = ""
		13:
			text.text = "Friday"
		14:
			text.text += "\nNight"
		15:
			text.text += "\nFunkin"
		16:
			intro()

func intro():
	var flashObj = $"../Flash"
	flashObj.visible = true
	
	var colorRect = flashObj.get_node("ColorRect")
	
	var tween = flashObj.get_node("Tween")
	
	tween.stop_all()
	
	tween.interpolate_property(
		colorRect,
		"color",
		colorRect.color,
		Color(1,1,1,0),
		AudioHandler.get_node("Confirm Sound").stream.get_length(),
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	tween.start()
	
	queue_free()
	
	enter_text.stop_shit = false
	
	Scenes.startup = false
