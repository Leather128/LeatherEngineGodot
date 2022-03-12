extends Node2D

export(Texture) var ready_texture = preload("res://Assets/Images/UI/Countdown/ready.png")
export(Texture) var set_texture = preload("res://Assets/Images/UI/Countdown/set.png")
export(Texture) var go_texture = preload("res://Assets/Images/UI/Countdown/go.png")

export(Texture) var health_bar_texture = preload("res://Assets/Images/UI/healthBar.png")

export(String) var rating_path = "res://Assets/Images/UI/Ratings/"
export(String) var numbers_path = "res://Assets/Images/UI/Ratings/"

export(SpriteFrames) var notes_texture = preload("res://Assets/Images/Notes/default/default.res")
export(SpriteFrames) var strums_texture = preload("res://Assets/Images/Notes/default/default.res")

# Uses this because manually putting each texture in is a pain in the ass #
export(String) var held_note_path = "res://Assets/Images/Notes/default/held/"
