extends Cutscene

onready var bf = $"../".bf
onready var dad = $"../".dad
onready var gf = $"../".gf

func _ready():
	$"../Camera2D".position = gf.position + Vector2(75, -350)
	
	bf.play_animation("hey", true)
	
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	dad.play_animation("singLEFT", true)
	gf.play_animation("scared", true)
	
	var tween = Tween.new()
	tween.interpolate_property(bf, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5)
	add_child(tween)
	tween.start()
	
	t = Timer.new()
	t.set_wait_time(2.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	tween.queue_free()
	
	emit_signal("finished")
	
	$"../Camera2D".position = bf.position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	t = Timer.new()
	t.set_wait_time(0.25)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	tween = Tween.new()
	tween.interpolate_property(bf, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75)
	add_child(tween)
	tween.start()
	
	t = Timer.new()
	t.set_wait_time(0.75)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	tween.queue_free()
