extends Node2D

export(Vector2) var camOffset = Vector2(0,0)
export(bool) var danceLeftAndRight = false
export(Color) var health_bar_color = Color(1,0,0,1)
export(Texture) var health_icon = preload("res://Assets/Images/Icons/bf-icons.png")
export(bool) var dances = true
export(String) var death_character = "bf-dead"

var danceLeft = false

var timer:float = 0.0

var last_anim:String = ""

var is_group_char:bool = true

func _ready():
	if dances:
		dance(true)

func _process(delta):
	if dances:
		if last_anim != "idle" and !last_anim.begins_with("dance"):
			timer += delta
			
			var multiplier:float = 4
			
			if name.to_lower() == "dad":
				multiplier = 6.1
			
			if timer >= Conductor.timeBetweenSteps * multiplier * 0.001:
				dance(true)
				timer = 0.0

func play_animation(animation, _force = true, character:int = 0):
	if name != "_":
		last_anim = animation
		
		if character <= len(get_children()) - 1:
			if "dances" in get_child(character):
				get_child(character).play_animation(animation)
				get_child(character).timer = 0

func dance(force = null, is_alt = false):
	if force == null:
		force = danceLeftAndRight
	
	for child in get_children():
		if "dances" in child:
			child.dance(null, is_alt)

func is_dancing():
	var dancing = false
	
	for child in get_children():
		if "dances" in child:
			if child.is_dancing():
				dancing = true
	
	return dancing

func has_anim(anim: String, character: int = 0):
	if get_child(character):
		return get_child(character).has_anim(anim)
