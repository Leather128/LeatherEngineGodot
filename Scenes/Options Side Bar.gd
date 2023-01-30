extends Node2D

# selecting stuff
var selected: int = 0
var is_selecting: bool = true

# cool options
onready var options: Node2D = $"../Options"

# tabs shit
onready var tabs_obj: Node2D = $Tabs

onready var tabs: Array = tabs_obj.get_children()
onready var tab_count: int = tabs_obj.get_child_count()

# other shit
var tween = Tween.new()

func _ready():
	# setup stuff
	add_child(tween)
	change_item(0)
	options.can_move = false

func _process(_delta):
	if is_selecting:
		if Input.is_action_just_pressed("ui_back"):
			Scenes.switch_scene("Main Menu")
		
		if Input.is_action_just_pressed("ui_down"):
			change_item(1)
		if Input.is_action_just_pressed("ui_up"):
			change_item(-1)
		if Input.is_action_just_pressed("ui_right"):
			is_selecting = false
			
			tabs_obj.get_child(selected).modulate.a = 0.6
			AudioHandler.play_audio("Scroll Menu")
			
			options.can_move = true
	else:
		if Input.is_action_just_pressed("ui_left") and options.can_move:
			is_selecting = true
			
			tabs_obj.get_child(selected).modulate.a = 1
			AudioHandler.play_audio("Scroll Menu")
			
			options.can_move = false

func change_item(amount: int = 0):
	selected += amount
	
	if selected < 0:
		selected = tab_count - 1
	if selected > tab_count - 1:
		selected = 0
	
	AudioHandler.play_audio("Scroll Menu")
	
	var selected_tab = tabs_obj.get_child(selected)
	
	for tab in tabs:
		if tab != selected_tab:
			tab.modulate.a = 0.6
			tween.interpolate_property(tab, "rect_position:x", tab.rect_position.x, 13, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		else:
			tab.modulate.a = 1
			tab.rect_position.x = 13
	
	tween.interpolate_property(selected_tab, "rect_position:x", selected_tab.rect_position.x, selected_tab.rect_position.x + 15, 0.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	for child in options.get_children():
		options.remove_child(child)
		child.queue_free()
	
	for option in selected_tab.get_children():
		var new_option = option.duplicate()
		new_option.visible = true
		new_option.position = Vector2(0,0)
		
		options.add_child(new_option)
	
	options.selected = 0
	options.update_options()
	
	Discord.update_presence("In the Options Menu", "Tab: " + selected_tab.name)
