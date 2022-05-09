extends StaticBody2D

var timer:float = 0.0

func _process(delta):
	timer += delta
	
	position.x = 306 + (sin(timer * 10) * 50)
	position.y = 149 + (sin(timer * 10) * 50)
