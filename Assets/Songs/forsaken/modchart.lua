function start (song)

end

function update (elapsed)
	local currentBeat = (songPos / 1000)*(bpm/140)
	for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
end
