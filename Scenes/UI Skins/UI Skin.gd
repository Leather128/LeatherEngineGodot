extends Node

export(Texture) var ready_texture = preload("res://Assets/Images/UI/Countdown/ready.png")
export(Texture) var set_texture = preload("res://Assets/Images/UI/Countdown/set.png")
export(Texture) var go_texture = preload("res://Assets/Images/UI/Countdown/go.png")

export(float) var countdown_scale = 1

export(Texture) var health_bar_texture = preload("res://Assets/Images/UI/healthBar.png")

export(String) var rating_path = "res://Assets/Images/UI/Ratings/"
export(String) var numbers_path = "res://Assets/Images/UI/Ratings/"

export(float) var rating_scale = 0.7
export(float) var number_scale = 0.6

export(SpriteFrames) var notes_texture = preload("res://Assets/Images/Notes/default/default.res")
export(SpriteFrames) var strums_texture = preload("res://Assets/Images/Notes/default/default.res")

export(float) var note_scale = 1
export(float) var strum_scale = 1

export(Vector2) var note_hold_scale = Vector2(1,1)

# Uses this because manually putting each texture in is a pain in the ass #
export(String) var held_note_path = "res://Assets/Images/Notes/default/held/"
