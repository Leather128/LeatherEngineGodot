extends Character

onready var og_scale_x: float = scale.x
onready var og_pos_y: float = position.y

var tween = Tween.new()

onready var game = $"../"

func _ready() -> void:
	add_child(tween)

func play_animation(animation, _force = true, _character:int = 0):
	if name != "_":
		if animation != "idle":
			scale.x = og_scale_x
			
			position.y = og_pos_y
			tween.stop_all()
			
			game.player_icon.flip_h = scale.x == og_scale_x
		
		last_anim = animation
		
		if !anim_player:
			anim_player = $AnimationPlayer
			anim_sprite = $AnimatedSprite
		
		if anim_player.has_animation(animation):
			anim_player.stop()
			
			if anim_sprite:
				anim_sprite.stop()
			
			if anim_player:
				anim_player.play(animation)

func dance(force = null, alt = null):
	var can = false
	
	if last_anim.ends_with("-alt") and alt == null:
		alt = true
	
	if danceLeftAndRight and last_anim.begins_with("dance"):
		force = true
	
	if force == null and danceLeftAndRight:
		can = anim_player.current_animation == "" or anim_player.current_animation.begins_with("dance")
	else:
		can = force or anim_player.current_animation == ""
	
	if og_pos_y:
		scale.x *= -1
		
		position.y = og_pos_y - 20
		
		tween.stop_all()
		tween.interpolate_property(self, "position:y", og_pos_y - 20, og_pos_y, 0.15, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()
		
		game.player_icon.flip_h = scale.x == og_scale_x
	
	if can:
		if danceLeftAndRight:
			danceLeft = !danceLeft
				
			if danceLeft:
				play_animation("danceLeft", force)
				
				if alt:
					play_animation("danceLeft-alt", force)
			else:
				play_animation("danceRight", force)
				
				if alt:
					play_animation("danceRight-alt", force)
		else:
			play_animation("idle", force)
			
			if alt:
				play_animation("idle-alt", force)
			
