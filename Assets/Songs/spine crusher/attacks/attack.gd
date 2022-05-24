class_name SansAttack
extends Node2D

# just a simple class to hold some variables and functions that pretty much every attack needs :D

var bullet = preload("res://Assets/Songs/spine crusher/attacks/bullet.tscn")

onready var game = $"../"

onready var box = game.get_node("Box")
onready var soul = game.get_node("Soul")

var attack_timer:float = 0.0
var th:float = 0.0

var tween = Tween.new()

func _ready():
	add_child(tween)

func _process(delta):
	th = th + (delta * 60)
	
	while attack_timer < floor(th):
		attack_step()
		attack_timer += 1

func attack_step():
	pass

func spawn_bullet(type, x, y, hsp:float = 0, vsp:float = 0, dmg:float = 1, ang:float = 0, exArg = null, exArg2 = null):
	var new_bullet = bullet.instance()
	new_bullet.type = type
	
	new_bullet.position.x = box.global_position.x + x
	new_bullet.position.y = box.global_position.y + y
	
	new_bullet.hsp = hsp
	new_bullet.vsp = vsp
	
	new_bullet.dmg = dmg
	new_bullet.ang = ang
	
	new_bullet.exArg = exArg
	new_bullet.exArg2 = exArg2
	
	if dmg == 0:
		new_bullet.safe = true
	
	if type == 'plat1' or type == 'plat2' or type == 'plat3':
		new_bullet.plat = true
		new_bullet.safe = true
	
	new_bullet.texture = load("res://Assets/Images/Modcharts/Undertale/bullets/" + type + ".png")
	new_bullet.scale = Vector2(2,2)
	new_bullet.modulate.a = 0
	
	new_bullet.rotation_degrees = ang
	
	var collisioner = new_bullet.get_node("StaticBody2D/CollisionShape2D")
	collisioner.shape = RectangleShape2D.new()
	collisioner.shape.extents = new_bullet.texture.get_size() / Vector2(2,2)
	
	collisioner.get_node("ColorRect").rect_size = collisioner.shape.extents * Vector2(2,2)
	collisioner.get_node("ColorRect").rect_position = -1 * collisioner.get_node("ColorRect").rect_size
	
	tween.interpolate_property(new_bullet, "modulate:a", 0, 1, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	box.add_child(new_bullet)
