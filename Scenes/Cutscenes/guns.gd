extends Cutscene

onready var bf = $"../".bf
onready var dad = $"../".dad
onready var gf = $"../".gf
onready var camera = $"../Camera2D"

onready var guns = $"Guns Cutscene"

onready var tank_1 = $"Tankman 1"

onready var music = $Music

onready var hud = $"../UI"

onready var game = $"../"

var move_hud = true

var good_cam_zoom = Vector2(1,1)

onready var def_cam = $"../".defaultCameraZoom

onready var mod = $"../UI/Modulate"

func _ready():
	mod.color.a = 0
	
	music.play()
	
	camera.position = dad.position + dad.camOffset + Vector2(-175, -25)
	guns.play()
	
	dad.visible = false
	
	tank_1.visible = true
	tank_1.frame = 0
	tank_1.position = dad.position
	tank_1.play("cutscene")
	
	var tween = Tween.new()
	tween.interpolate_property(self, "good_cam_zoom", Vector2(1,1), Vector2(0.9,0.9), 1.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 0.2)
	add_child(tween)
	tween.start()
	
	yield(get_tree().create_timer(4), "timeout")
	
	gf.play_animation("sad")
	gf.dances = false
	
	tween.interpolate_property(self, "good_cam_zoom", Vector2(0.9,0.9), Vector2(0.8,0.8), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(guns.stream.get_length() - 4), "timeout")
	
	camera.position = bf.position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	game.cam_locked = true
	
	gf.dances = true
	
	emit_signal("finished")
	
	camera.position = dad.position + dad.camOffset
	
	move_hud = false
	
	tank_1.visible = false
	dad.visible = true
	
	mod.color.a = 1
	
	tween.interpolate_property(self, "good_cam_zoom", Vector2(0.8,0.8), Vector2(def_cam,def_cam), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	game.cam_locked = false
	
	queue_free()

func _physics_process(_delta):
	if move_hud:
		hud.offset.y = -720

func _process(_delta):
	camera.zoom = good_cam_zoom
