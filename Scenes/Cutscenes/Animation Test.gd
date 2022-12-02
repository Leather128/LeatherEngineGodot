extends Cutscene

func _ready() -> void:
	camera.position = gf.position + Vector2(75, -350)
	
	bf.play_animation("hey", true)
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	dad.play_animation("singLEFT", true)
	gf.play_animation("scared", true)
	
	var tween = Tween.new()
	tween.interpolate_property(bf, "modulate", Color(1,1,1,1), Color(1,1,1,0), 0.5)
	add_child(tween)
	tween.start()
	
	yield(get_tree().create_timer(2.5), "timeout")
	
	tween.queue_free()
	
	emit_signal("finished")
	
	camera.position = bf.position + Vector2(-1 * bf.camOffset.x, bf.camOffset.y)
	
	yield(get_tree().create_timer(0.25), "timeout")
	
	tween = Tween.new()
	tween.interpolate_property(bf, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.75)
	add_child(tween)
	tween.start()
	
	yield(get_tree().create_timer(0.75), "timeout")
	
	tween.queue_free()
