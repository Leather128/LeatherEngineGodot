extends Cutscene

onready var bf = $"../".bf
onready var dad = $"../".dad
onready var gf = $"../".gf
onready var camera = $"../Camera2D"

onready var cutscene = $Cutscene

onready var hud = $"../UI"

onready var tank_1 = $"Tankman 1"
onready var tank_2 = $"Tankman 2"

onready var game = $"../"

var parts = []

var move_hud = true

var good_cam_zoom = Vector2(1,1)

onready var mod = $"../UI/Modulate"

func _ready():
	mod.color.a = 0
	
	for i in 8:
		parts.push_back(get_node("Part " + str(i + 1)))
		parts[i].position = gf.position
	
	cutscene.play()
	
	camera.position = dad.position + dad.camOffset + Vector2(50, 0)
	
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(camera, "position:x", camera.position.x, camera.position.x - 50, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	dad.visible = false
	gf.visible = false
	bf.z_index += 1
	
	parts[0].visible = true
	
	tank_1.position = dad.position
	tank_1.visible = true
	tank_1.frame = 0
	tank_1.play("cutscene")
	
	yield(get_tree().create_timer(15.5), "timeout")
	
	camera.position.x += 150
	camera.position.y -= 150
	
	tween.interpolate_property(self, "good_cam_zoom", good_cam_zoom, Vector2(0.8,0.8), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	play_part(1)
	
	yield(get_tree().create_timer(1.4), "timeout")
	
	tween.interpolate_property(self, "good_cam_zoom", good_cam_zoom, Vector2(1.2,1.2), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	
	play_part(2)
	
	parts[0].frames = null
	parts[0].visible = false
	
	yield(get_tree().create_timer(1), "timeout")
	
	parts[1].frames = null
	parts[1].visible = false
	parts[2].frames = null
	parts[2].visible = false
	parts[6].frames = null
	parts[6].visible = false
	
	play_part(4)
	play_part(5, false)
	play_part(6, false)
	
	yield(get_tree().create_timer(2), "timeout")
	
	camera.position = dad.position + dad.camOffset + Vector2(50, 0)
	
	tank_1.visible = false
	tank_1.queue_free()
	
	tank_2.position = dad.position
	tank_2.visible = true
	tank_2.frame = 0
	tank_2.play("cutscene")
	
	yield(get_tree().create_timer(2), "timeout")
	
	parts[3].frames = null
	parts[3].visible = false
	
	parts[4].frames = null
	parts[4].visible = false
	
	parts[5].frames = null
	parts[5].visible = false
	
	play_part(8)
	
	yield(get_tree().create_timer(10), "timeout")
	
	camera.position = bf.position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y) + Vector2(50, 0)
	
	bf.timer = 0
	bf.play_animation("singUPmiss")
	bf.dances = false
	
	good_cam_zoom = Vector2(0.7, 0.7)
	
	yield(get_tree().create_timer(0.75), "timeout")
	
	camera.position = dad.position + dad.camOffset
	
	good_cam_zoom = Vector2(1, 1)
	
	bf.dances = true
	
	yield(get_tree().create_timer(3.25), "timeout")
	
	play_part(1)
	
	dad.visible = true
	gf.visible = true
	
	game.cam_locked = true
	
	emit_signal("finished")
	
	camera.position = dad.position + dad.camOffset
	
	move_hud = false
	
	mod.color.a = 1
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	game.cam_locked = false
	
	queue_free()

func _physics_process(_delta):
	if move_hud:
		hud.offset.y = -720

func _process(_delta):
	camera.zoom = good_cam_zoom

func play_part(part_index: int, hide_previous: bool = true):
	for i in len(parts):
		var part = parts[i]
		
		if i == part_index - 1:
			part.visible = true
			part.frame = 0
			part.play("cutscene")
		elif hide_previous:
			part.visible = false
