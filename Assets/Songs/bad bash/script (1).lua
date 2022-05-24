function onUpdate()

    songPos = getSongPosition()
    
    local curBeating = (songPos/2000)*(curBpm/60)

	doTweenAngle('hud', 'hud.angle', 15.5 - 20*math.sin((curBeating + 12*12)*math.pi), 2)

function onStepHit()

end