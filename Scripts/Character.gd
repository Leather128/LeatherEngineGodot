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

func play_animation(animation, _force = true):
	last_anim = animation
	
	$AnimationPlayer.stop()
	
	if get_node("AnimatedSprite") != null:
		get_node("AnimatedSprite").stop()
	
	$AnimationPlayer.play(animation)

func dance(force = null):
	if force == null:
		force = danceLeftAndRight
	
	if force or $AnimationPlayer.current_animation == "":
		if danceLeftAndRight:
			danceLeft = !danceLeft
				
			if danceLeft:
				play_animation("danceLeft", force)
			else:
				play_animation("danceRight", force)
		else:
			play_animation("idle", force)

func is_dancing():
	var dancing = true
		
	if last_anim != "idle" and !last_anim.begins_with("dance"):
		dancing = false
	
	return dancing
