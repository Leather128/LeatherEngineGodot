extends Node2D

onready var text: Label = $Text

var intro_texts: Array = []
var random_text: int

onready var enter_text: AnimatedSprite = $"../Enter Txt"

var is_duckified: bool = false
onready var duck: Sprite = $Duck

func _ready() -> void:
	if rand_range(0, 193.9) <= 1:
		is_duckified = true
	
	if Scenes.startup:
		randomize()
		
		var file: File = File.new()
		file.open("res://Assets/intro_text.txt", File.READ)
		intro_texts = file.get_as_text().split("\n")
		
		random_text = floor(rand_range(0, len(intro_texts)))
		
		Conductor.connect("beat_hit", self, "beat_hit")
		
		enter_text.stop_shit = true
	else:
		queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		intro()

func beat_hit() -> void:
	duck.visible = false
	
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
			if is_duckified:
				text.text += "\n"
				duck.visible = true
			else:
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
			if is_duckified:
				text.text = "Duck"
			else:
				text.text = "Friday"
		14:
			text.text += "\nNight"
		15:
			if is_duckified:
				text.text += "\nQuackin"
			else:
				text.text += "\nFunkin"
		16:
			intro()

func intro() -> void:
	var flash: Node2D = $"../Flash"
	flash.visible = true
	
	var flash_rect: ColorRect = flash.get_node("ColorRect")
	
	var tween: Tween = flash.get_node("Tween")
	tween.stop_all()
	
	tween.interpolate_property(
		flash_rect,
		"color",
		flash_rect.color,
		Color(1.0, 1.0, 1.0, 0.0),
		AudioHandler.get_node("Confirm Sound").stream.get_length(),
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	tween.start()
	queue_free()
	
	enter_text.stop_shit = false
	Scenes.startup = false
