extends Node

var songName:String = "tutorial"
var songDifficulty:String = "hard"

var weekSongs:Array = []

var freeplay:bool = false

var scroll_speed:float = 1.0

var key_count:int = 4

var death_character_name:String = "bf-dead"
var death_character_pos:Vector2 = Vector2()
var death_character_cam:Vector2 = Vector2()

var song_multiplier: float = 1.0

var do_cutscenes:bool = true

# song data lmao (used for loading into Gameplay i think)
var song:Dictionary
