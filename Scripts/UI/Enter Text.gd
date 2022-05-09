extends Node2D

var pressed = false

var stop_shit = false

var funnyTimer = 0.0

onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.play("idle")

func _process(elapsed):
	if Input.is_action_just_pressed("ui_accept") and !pressed:
		if !stop_shit:
			animated_sprite.play("pressed")
			AudioHandler.play_audio("Confirm Sound")
			pressed = true
		else:
			stop_shit = false
			
	if pressed and !stop_shit:
		if Settings.get_data("flashingLights"):
			funnyTimer += elapsed
		else:
			if funnyTimer != -1000:
				funnyTimer = AudioHandler.get_node("Confirm Sound").stream.get_length() + 0.1
		
		if funnyTimer > AudioHandler.get_node("Confirm Sound").stream.get_length():
			switch_to_menu()
		
func switch_to_menu():
	Scenes.switch_scene("Main Menu")
	
	funnyTimer = -1000
