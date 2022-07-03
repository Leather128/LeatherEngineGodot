extends Node2D

onready var sprite = $"../AnimatedSprite"

export var length:int = 10
export var delay:int = 3
export var alpha:float = 0.4
export var diff:float = 0.05

var frame:float = 0

var _recentPositions:Array = []
var _recentFrames:Array = []

var spritePosition:Vector2 = Vector2()

func _ready() -> void:
	increaseLength(length)

func _process(delta: float) -> void:
	frame += delta
	
	if frame >= (1.0 / 60.0) * delay && length >= 1:
		frame = 0
		
		var spritePosition:Vector2 = sprite.position
		
		if _recentPositions.size() == length - 1:
			_recentPositions.pop_back()
		if _recentFrames.size() == length - 1:
			_recentFrames.pop_back()
		
		spritePosition = Vector2(sprite.position.x, sprite.position.y)
		_recentPositions.push_front(spritePosition)
		_recentFrames.push_front([sprite.offset, sprite.animation, sprite.frame])
		
		var trailSprite:AnimatedSprite
		
		for i in _recentPositions.size():
			trailSprite = get_child(i)
			trailSprite.position.x = _recentPositions[i].x
			trailSprite.position.y = _recentPositions[i].y
			
			trailSprite.offset = _recentFrames[i][0]
			trailSprite.animation = _recentFrames[i][1]
			trailSprite.frame = _recentFrames[i][2]
			
			trailSprite.visible = true

func increaseLength(amount:int) -> void:
	if amount < 1:
		return
	
	for i in amount:
		var trailSprite = sprite.duplicate()
		trailSprite.playing = false
		add_child(trailSprite)
		
		trailSprite.modulate.a = alpha
		alpha -= diff

		if trailSprite.modulate.a <= 0:
			trailSprite.visible = false
