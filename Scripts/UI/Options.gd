extends Node2D

var selected = 0

var can_move = true

func _ready():
	update_options()

func _process(_delta):
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

func update_options():
	for option in get_children():
		if option == get_children()[selected]:
			option.modulate.a = 1
			$"../Camera2D".position.y = option.global_position.y
		else:
			option.modulate.a = 0.6
	
	AudioHandler.play_audio("Scroll Menu")
