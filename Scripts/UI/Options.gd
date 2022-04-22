extends Node2D

var selected = 0

var can_move = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	for child in get_children():
		child.position = Vector2(0, 0)
	
	update_options()

func _process(delta):
	if can_move:
		if Input.is_action_just_pressed("ui_up"):
			selected -= 1
		if Input.is_action_just_pressed("ui_down"):
			selected += 1
		
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down"):
			if selected > len(get_children()) - 1:
				selected = 0
			if selected < 0:
				selected = len(get_children()) - 1
			
			update_options()
		
		if Input.is_action_just_pressed("ui_accept"):
			var selected_option = get_children()[selected]
			selected_option.open_option()
			
			if selected_option.is_bool:
				selected_option.update_checkbox()
				Settings.set_data(selected_option.save_name, selected_option.value)
		
		if Input.is_action_just_pressed("ui_back"):
			Scenes.switch_scene("Main Menu")
	
	for i in get_child_count():
		set_pos_text(get_child(i), i - selected, delta)

func update_options():
	for option in get_children():
		if option == get_child(selected):
			option.modulate.a = 1
		else:
			option.modulate.a = 0.6
	
	AudioHandler.play_audio("Scroll Menu")

func set_pos_text(text, targetY, elapsed):
	var scaledY = range_lerp(targetY, 0.0, 1.0, 0.0, 1.3)
	
	var lerpVal = clamp(elapsed * 9.6, 0.0, 1.0)
	
	# 120 = yMult, 720 = FlxG.height
	text.position.y = lerp(text.position.y, (scaledY * 120.0) + (720.0 * 0.48), lerpVal);

	text.position.x = lerp(text.position.x, (targetY * 20.0) + 90.0, lerpVal)
