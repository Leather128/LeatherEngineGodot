extends CanvasLayer

onready var box = $Box

onready var outline = box.get_node("Outline")
onready var black = outline.get_node("Black")

onready var top = box.get_node("Top")
onready var down = box.get_node("Bottom")
onready var left = box.get_node("Left")
onready var right = box.get_node("Right")

onready var top_shape = top.shape
onready var down_shape = down.shape
onready var left_shape = left.shape
onready var right_shape = right.shape

onready var soul = $Soul

var tween = Tween.new()

func _ready():
	add_child(tween)
	
	resize_box(640, 480, 1.5)
	
	randomize()
	
	Conductor.connect("beat_hit", self, "beat_hit")

func resize_box(width:int = 640, height:int = 480, duration:float = 1):
	tween.interpolate_property(outline, "rect_size", outline.rect_size, Vector2(width, height), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(black, "rect_size", black.rect_size, Vector2(width - 8, height - 8), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	
	# shit that no move pos
	tween.interpolate_property(top_shape, "extents", top_shape.extents, Vector2(width, 2), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(left_shape, "extents", left_shape.extents, Vector2(2, height - 2), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	
	# shit that moves pos
	tween.interpolate_property(down_shape, "extents", down_shape.extents, Vector2(width, 2), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(right_shape, "extents", right_shape.extents, Vector2(2, height - 2), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	
	tween.interpolate_property(down, "position", down.position, Vector2(64, height - 2), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(right, "position", right.position, Vector2(width - 2, 64), duration, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	
	tween.start()

func beat_hit():
	if Conductor.curBeat % 8 == 0:
		resize_box(int(rand_range(128, 720)), int(rand_range(128, 480)), (Conductor.timeBetweenBeats / 1000.0) * 4.0)
		
		if soul.mode == 1:
			soul.switch_mode(0)
		else:
			soul.switch_mode(1)
