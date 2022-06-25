extends Node2D

onready var sprite = $"../AnimatedSprite"

export var length:int = 10
export var delay:int = 3
export var alpha:float = 0.4
export var diff:float = 0.05

var frame:int = 0

var _recentPositions:Array = []
var spritePosition:Vector2 = Vector2()

func _ready() -> void:
	increaseLength(length)

func _physics_process(delta: float) -> void:
	frame += 1
	
	if frame >= delay && length >= 1:
		frame = 0
		
		var spritePosition:Vector2 = sprite.position
		
		if _recentPositions.size() == length - 1:
			_recentPositions.pop_back()
		
		spritePosition = Vector2(sprite.position.x, sprite.position.y)
		_recentPositions.push_front(spritePosition)
		
		var trailSprite:AnimatedSprite
		
		for i in _recentPositions.size():
			trailSprite = get_child(i)
			trailSprite.position.x = _recentPositions[i].x
			trailSprite.position.y = _recentPositions[i].y
			
			trailSprite.offset = sprite.offset
			trailSprite.animation = sprite.animation
			trailSprite.frame = sprite.frame
			
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
