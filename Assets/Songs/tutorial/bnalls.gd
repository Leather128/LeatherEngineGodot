extends Node2D

"""
function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
end


function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(defaultStrum0Y + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
end
"""

func _ready():
	print("Song: " + $"../".songData.song + " @ " + str(Conductor.bpm) + " donwscroll: " + str(Settings.get_data("downscroll")))

func _process(delta):
	var currentBeat = (Conductor.songPosition / 1000) * (Conductor.bpm / 60)
	
	for i in 8:
		if i < 4:
			$"../UI/Enemy Strums".get_child(i % 4).global_position.y = $"../UI/Player Strums".global_position.y + 10 * cos((currentBeat + i * 0.25) * PI)
		else:
			$"../UI/Player Strums".get_child(i % 4).global_position.y = $"../UI/Player Strums".global_position.y + 10 * cos((currentBeat + i * 0.25) * PI)
