extends Panel

onready var path = $Path
onready var button = $Button

onready var sprite_data = $SpriteData

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func convert_xml():
	if path.text != "":
		var path_string:String
		
		if path.text.ends_with(".png") or path.text.ends_with(".xml"):
			path_string = "res://" + path.text.left(len(path.text) - 4)
		else:
			path_string = "res://" + path.text
		
		if path_string.begins_with("res://res://"):
			path_string = path_string.right(6)
		
		var texture = load(path_string + ".png")
		
		if texture != null:
			var frames = SpriteFrames.new()
			
			var xml = XMLParser.new()
			xml.open(path_string + ".xml")
			
			sprite_data.frames = frames
			
			while xml.read() == OK:
				var node_name = xml.get_node_name()
				
				if node_name.to_lower() == "subtexture":
					var animation_name = xml.get_named_attribute_value("name")
					animation_name = animation_name.left(len(animation_name) - 4)
					
					var frame_rect = Rect2(
						Vector2(
							xml.get_named_attribute_value("x"),
							xml.get_named_attribute_value("y")
						),
						Vector2(
							xml.get_named_attribute_value("width"),
							xml.get_named_attribute_value("height")
						)
					)
					
					var frame_size_data = Vector2(
						xml.get_named_attribute_value("frameWidth"),
						xml.get_named_attribute_value("frameHeight")
					)
					
					if frame_size_data == Vector2(0,0):
						frame_size_data = frame_rect.size
					
					var margin = Rect2(
						Vector2(
							-int(xml.get_named_attribute_value("frameX")),
							-int(xml.get_named_attribute_value("frameY"))
						),
						Vector2(
							int(xml.get_named_attribute_value("frameWidth")) - frame_rect.size.x,
							int(xml.get_named_attribute_value("frameHeight")) - frame_rect.size.y
						)
					)
					
					if margin.size.x < abs(margin.position.x):
						margin.size.x = abs(margin.position.x)
					if margin.size.y < abs(margin.position.y):
						margin.size.y = abs(margin.position.y)
					
					var frame_data = AtlasTexture.new()
					frame_data.atlas = texture
					frame_data.region = frame_rect
					frame_data.margin = margin
					frame_data.flags = Texture.FLAG_MIPMAPS
					frame_data.filter_clip = true
					
					if !frames.has_animation(animation_name):
						frames.add_animation(animation_name)
						frames.set_animation_loop(animation_name, false)
						frames.set_animation_speed(animation_name, 24)
					
					frames.add_frame(animation_name, frame_data)
			
			frames.remove_animation("default")
			ResourceSaver.save(path_string + ".res", frames, ResourceSaver.FLAG_COMPRESS)
			
			for anim in frames.animations:
				sprite_data.play(anim.name)
				yield(get_tree().create_timer(0.01), "timeout")
		else:
			print(path_string + " loading failed.")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		Scenes.switch_scene("Tools Menu")
