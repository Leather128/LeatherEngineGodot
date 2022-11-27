extends "res://Scripts/Stage.gd"

var timer: float = 0.0

var debs: Array = []

onready var game: Node2D = $"../"

onready var dad: Node2D = game.dad

onready var dad_point: Node2D = $"Dad Point"
onready var dad_point_pos: Vector2 = dad_point.position

onready var cam: Camera2D = game.camera

onready var bf_rock: AnimatedSprite = $"bf rock"
onready var gf_rock: AnimatedSprite = $"gf rock"

onready var bf_point: Node2D = $"Player Point"
onready var gf_point: Node2D = $"GF Point"

func _ready():
	for child in $ParallaxBackground/debs.get_children():
		debs.append([child, child.position.y])
	for child in $ParallaxBackground/debs2.get_children():
		debs.append([child, child.position.y])

func _process(delta):
	timer += delta * 1.5
	
	var i: int = 0
	
	for deb_data in debs:
		var deb = deb_data[0]
		var start_y = deb_data[1]
		
		deb.position.y = start_y + (sin(2 * (timer + i)) * 80)
		
		i += 1
	
	dad.position = Vector2(dad_point_pos.x + ((cos(timer) * 2) * 240), dad_point_pos.y + (sin(2 * timer) * 240))
	dad_point.position = dad.position
	
	if !game.cam_locked:
		if len(game.song_data["notes"]) - 1 >= game.curSection:
			if game.bf and dad:
				if !game.song_data["notes"][game.curSection]["mustHitSection"]:
					cam.position = dad.position + dad.camOffset
	
	game.bf.position.y = bf_point.position.y + (sin(2 * timer) * 20)
	game.gf.position.y = gf_point.position.y + (sin(2 * timer) * 80)
	
	bf_rock.position = Vector2(game.bf.position.x - 400, game.bf.position.y - 125)
	gf_rock.position = Vector2(game.gf.position.x - 325, game.gf.position.y - 100)
