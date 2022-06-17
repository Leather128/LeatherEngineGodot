extends Cutscene

onready var black_screen = $ColorRect
onready var lights = $Lights
onready var evil_point = $"Evil Point"

onready var hud_mod = game.get_node("UI/Modulate")

var good_cam_zoom:Vector2 = Vector2(0.5, 0.5)

func _ready():
	camera.position = evil_point.position
	
	hud_mod.color.a = 0
	
	yield(get_tree().create_timer(1), "timeout")
	
	black_screen.queue_free()
	lights.play()
	
	yield(get_tree().create_timer(0.8), "timeout")
	
	hud_mod.color.a = 1
	
	var tween = Tween.new()
	add_child(tween)
	
	tween.interpolate_property(self, "good_cam_zoom", Vector2(0.5, 0.5), Vector2(game.defaultCameraZoom, game.defaultCameraZoom), 2.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	
	yield(get_tree().create_timer(2.5), "timeout")
	
	emit_signal("finished")

func _process(_delta):
	camera.zoom = good_cam_zoom
