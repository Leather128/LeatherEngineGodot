extends Node

# notes lmao
signal player_note_hit(note, dir, type, character)
signal enemy_note_hit(note, dir, type, character)
signal note_hit(note, dir, type, character, must_hit)

signal note_miss(note, dir, type, character)

signal event_processed(event)
