extends CanvasLayer

onready var box = $Box

onready var outline = box.get_node("Outline")
onready var black = outline.get_node("Black")

onready var attack_name = box.get_node("Attack Name")

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

var events = []

var attack_cache = {}

var current_attack:Node2D

func _ready():
	add_child(tween)
	
	box.modulate.a = 0
	soul.modulate.a = 0
	soul.can_move = false
	
	resize_box(640, 480, 1.5)
	
	randomize()
	
	if File.new().file_exists("res://Assets/Songs/" + GameplaySettings.songName + "/events.json"):
		var file = File.new()
		file.open("res://Assets/Songs/" + GameplaySettings.songName + "/events.json", File.READ)
		
		var data = JSON.parse(file.get_as_text()).result.song
		
		for section in data.notes:
			for event in section.sectionNotes:
				if event[1] == -1:
					events.push_back([event[0], event[2], event[3], event[4]])
		
		events.sort_custom(self, "event_sort")

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

func _physics_process(_delta):
	for event in events:
		if event[0] <= Conductor.songPosition:
			# event[1] is event name
			match(event[1]):
				"boxOpen":
					if not event[2] in attack_cache and File.new().file_exists("res://Assets/Songs/" + GameplaySettings.songName + "/attacks/" + event[2] + ".tscn"):
						attack_cache[event[2]] = load("res://Assets/Songs/" + GameplaySettings.songName + "/attacks/" + event[2] + ".tscn")
						
					attack_name.text = event[2] + "\n" + event[3]
					
					if box.modulate.a == 0:
						tween.interpolate_property(box, "modulate:a", 0, 1, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						tween.interpolate_property(soul, "modulate:a", 0, 1, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
						tween.start()
					
					soul.switch_mode(0)
					
					soul.position.x = box.position.x + (outline.rect_size.x / 2)
					soul.position.y = box.position.y + (outline.rect_size.y / 2)
					
					soul.can_move = true
					
					if current_attack:
						remove_child(current_attack)
						current_attack.queue_free()
					
					if attack_cache.has(event[2]):
						var new_attack = attack_cache[event[2]].instance()
						add_child(new_attack)
						
						current_attack = new_attack
				"boxClose":
					tween.interpolate_property(box, "modulate:a", 1, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					tween.interpolate_property(soul, "modulate:a", 1, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
					
					soul.can_move = false
					
					tween.start()
					
					if current_attack:
						remove_child(current_attack)
						current_attack.queue_free()
						current_attack = null
			
			events.erase(event)
		else:
			break

func event_sort(a, b):
	return a[0] < b[0]
