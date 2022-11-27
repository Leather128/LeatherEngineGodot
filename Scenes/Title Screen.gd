extends Node2D

var started: bool = false

func _ready() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	
	Discord.update_presence("On the Title Screen")
	
	Conductor.change_bpm(102)
	AudioHandler.play_audio("Title Music")
	
	started = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_back"):
		get_tree().quit()
	
	if started:
		Conductor.songPosition += delta * 1000

var keys: Array = []

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		keys.append(event.scancode)
		
		# 940 661 = [57, 52, 48, 54, 54, 49]
		var code: Array = [57, 52, 48, 54, 54, 49]
		
		var final_index: int = 0
		
		for i in len(keys):
			if i <= len(code) - 1:
				if keys[i] != code[i]:
					keys = []
					final_index = 0
					break
			else:
				keys = []
				final_index = 0
				break
			
			final_index = i
		
		if final_index == len(code) - 1:
			print("YOUR DID IT!!!")
