extends Cutscene

# line stuff
export var sections:Array = []
var cur_section:int = 0
var frame_timer:float = 0.0

# onready
onready var text = $Text

onready var bf_port = $BF
onready var dad_port = $Senpai
onready var box = $DialogueBox
onready var hand = $Hand

onready var bg = $BG

onready var canvas_modulate = $CanvasModulate

onready var char_click = $"Character Sound"
onready var click_sound = $"Click Sound"

var tween:Tween = Tween.new()

var bg_timer:float = 0.0

func _ready():
	add_child(tween)
	
	update_text(false)

func _process(delta):
	bg_timer += delta
	
	if bg_timer >= 0.83:
		bg_timer = 0
		bg.color.a += (1.0 / 5.0) * 0.7
		
		if bg.color.a > 0.7:
			bg.color.a = 0.7
	
	if cur_section != -1:
		frame_timer += delta
		
		if frame_timer >= 0.04:
			if text.visible_characters + 1 <= len(text.text):
				text.visible_characters += 1
				char_click.play(0)
				frame_timer = 0
				hand.visible = false
			else:
				hand.visible = true
		
		if Input.is_action_just_pressed("ui_accept"):
			if len(sections) > cur_section + 1:
				update_text(true)
			else:
				click_sound.play(0)
				
				cur_section = -1
				
				tween.interpolate_property(canvas_modulate, "color", Color(1,1,1,1), Color(1,1,1,0), 1.2)
				tween.interpolate_property($Music, "volume_db", 0, -12, 1.2)
				
				tween.start()
				
				yield(get_tree().create_timer(1.2, false), "timeout")
				
				emit_signal("finished")
				queue_free()

func update_text(update_section:bool = true):
	if update_section:
		cur_section += 1
		click_sound.play(0)
	
	var cur_section_data:Dictionary = sections[cur_section]
	
	text.text = cur_section_data.text
	text.visible_characters = 0
	frame_timer = 0
	
	box.play("appear")
	box.frame = 0
	
	if cur_section_data.side.to_lower() == "bf":
		bf_port.visible = true
		dad_port.visible = false
	else:
		bf_port.visible = false
		dad_port.visible = true
	
	hand.visible = false
