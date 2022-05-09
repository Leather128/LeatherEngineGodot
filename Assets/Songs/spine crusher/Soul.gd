extends KinematicBody2D

var velocity:Vector2 = Vector2()

var speed:int = 300
var gravity:int = 15

var jump_power:float = 55
var jump_frames:int = 15

# 0 = red, 1 = blue
var mode:int = 1

onready var box = $"../Box"
onready var outline = box.get_node("Outline")

onready var sprite = $Sprite

func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
	
	# you're blue now!
	if mode == 1:
		velocity.y += gravity
		
		if is_on_floor():
			jump_frames = 8
		elif not Input.is_action_pressed("ui_up"):
			jump_frames = 0
		
		if Input.is_action_pressed("ui_up") and jump_frames > 0:
			if velocity.y > 0:
				velocity.y = -jump_power * 3
			
			velocity.y -= jump_power
			jump_frames -= 1
	elif mode == 0:
		if Input.is_action_pressed("ui_up"):
			velocity.y = -speed
		elif Input.is_action_pressed("ui_down"):
			velocity.y = speed
		else:
			velocity.y = lerp(velocity.y, 0, 0.2)
	
	move_and_slide(velocity, Vector2.UP)
	
	global_position.x = clamp(global_position.x, box.global_position.x, box.global_position.x + outline.rect_size.x)
	global_position.y = clamp(global_position.y, box.global_position.y, box.global_position.y + outline.rect_size.y)
	
	if global_position.x == box.global_position.x:
		global_position.x += 4
	elif global_position.x == box.global_position.x + outline.rect_size.x:
		global_position.x -= 4
	
	if global_position.y == box.global_position.y:
		global_position.y += 4
	elif global_position.y == box.global_position.y + outline.rect_size.y:
		global_position.y -= 4

func switch_mode(_mode:int = 0):
	mode = _mode
	
	match(mode):
		0:
			sprite.modulate = Color(1,0,0,1)
		1:
			sprite.modulate = Color(0,0,1,1)
