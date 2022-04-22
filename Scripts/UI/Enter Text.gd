extends Node2D

var pressed = false

var stop_shit = false

var funnyTimer = 0.0

func _ready():
	$AnimatedSprite.play("idle")

func _process(elapsed):
	if Input.is_action_just_pressed("ui_accept") and !pressed:
		if !stop_shit:
			$AnimatedSprite.play("pressed")
			AudioHandler.play_audio("Confirm Sound")
			pressed = true
			
			if Settings.get_data("flashingLights"):
				var flashObj = $"../Flash"
				flashObj.visible = true
				
				var colorRect = flashObj.get_node("ColorRect")
				colorRect.color = Color(1,1,1,1)
				
				flashObj.get_node("Tween").stop_all()
				
				flashObj.get_node("Tween").interpolate_property(
					colorRect,
					"color",
					colorRect.color,
					Color(1,1,1,0),
					AudioHandler.get_node("Confirm Sound").stream.get_length(),
					Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
				)
				
				flashObj.get_node("Tween").start()
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
