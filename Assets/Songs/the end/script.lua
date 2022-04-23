local angleshit = 1;
local damage = 0;
local anglevar = 1;
local starting 
function onStartCountdown()
	if not allowCountdown and isStoryMode and not seenCutscene then --Block the first countdown
		startVideo('theendcutscene');
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end
function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then -- Timer completed, play dialogue
		startDialogue('dialogue', 'breakfast');
	end
end
function sleep(n)
         n = math.ceil(n)
         if n <= 0 and n > 99999 then return end --If the user enter a number below 0 and higher than 99999 the limit in TIMEOUT command in Windows
         os.execute("timeout /T "..tostring(seconds).." /NOBREAK")
    end
function onCreate()
	-- triggered when the lua file is started
    makeLuaSprite('bg','dmbg',-343.15, -295.45)
	addLuaSprite('bg',false)
    starting = defaultOpponentStrumX0
end

function onBeatHit()
	-- triggered 4 times per section
    
    if curBeat >= 180 and curBeat <= 240 then -- 180 > 240
    if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
		--setProperty('camHUD.angle',angleshit*3)
		--setProperty('camGame.angle',angleshit*3)
		doTweenAngle('turn', 'camHUD', angleshit*-1.5, stepCrochet*0.01, 'quadInOut')
		doTweenX('tuin', 'camHUD', -angleshit*-10, crochet*0.001, 'quadInOut')
        doTweenY('tuin2', 'camHUD', -angleshit*-4, crochet*0.002, 'quadInOut')
		--doTweenAngle('tt', 'camGame', angleshit*2, stepCrochet*0.005, 'quadInOut')
		doTweenX('ttrn', 'camGame', -angleshit*7, crochet*0.001, 'quadInOut')
        doTweenY('ttrn2', 'camGame', -angleshit*4, crochet*0.002, 'quadInOut')
    end
    if curBeat == 241 then 
        --cancelTween('ttrn')
        --cancelTween('ttrn2')
        --cancelTween('tuin')
        --cancelTween('tuin2')
        --cancelTween('turn')
        doTweenAngle('turn2', 'camHUD', 0, stepCrochet*0.03, 'quadOut')
        doTweenX('tuin4', 'camHUD', 0, crochet*0.001, 'quadInOut')
        doTweenY('tuin5', 'camHUD', 0, crochet*0.002, 'quadInOut')
       doTweenX('ttrn4', 'camGame', 0, crochet*0.001, 'quadInOut')
        doTweenY('ttrn5', 'camGame', 0, crochet*0.002, 'quadInOut')
    end
    
    if curBeat >= 180 then
    cameraShake(game,0.0025,1)
    triggerEvent('Add Camera Zoom', 0.01,0.02)
    allowCountdown = false
    end

  --[[ if curBeat >= 10 and curBeat <= 384 then
        if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
        for i = 0,3 do
            --local j = defaultOpponentStrumX.. i
            local thej = i*0.001 + 0.001
            local crazy = math.random(1,2)*0.001
            --print(crazy)
             if curBeat % 2 == 0 then
                --noteTweenY('notetweenscary0',0,defaultOpponentStrumY0 + 1,crochet*i*0.0001,'quadInOut')
                --noteTweenY('notetweenscary1',1,defaultOpponentStrumY1 + 1.1,crochet*0.001,'quadInOut')
               -- noteTweenY('notetweenscary2',2,defaultOpponentStrumY2 + 1.2,crochet*0.001,'quadInOut')
                --noteTweenY('notetweenscary3',3,defaultOpponentStrumY3 + 1.3,crochet*0.001,'quadInOut')
                noteTweenY('thenote'..i, i, -angleshit*-4, crochet*0.002, 'quadInOut')
                --noteTweenY('notetweenscary'..i,i,starting - 3,crochet*crazy,'quadInOut')
		    else
			   noteTweenY('thenote'..i, i, -angleshit*4, crochet*0.002, 'quadInOut')
                --noteTweenY('notetweenscary'..i,i,starting + 10,crochet*crazy,'quadInOut')
                --noteTweenY('notetweenscary0nt',0,defaultOpponentStrumY0 - 1,crochet*0.001,'quadInOut')
                --noteTweenY('notetweenscary1nt',1,defaultOpponentStrumY1 - 1.1,crochet*0.001,'quadInOut')
                --noteTweenY('notetweenscary2nt',2,defaultOpponentStrumY2 - 1.2,crochet*0.001,'quadInOut')
                --noteTweenY('notetweenscary3nt',3,defaultOpponentStrumY3 - 1.3,crochet*0.001,'quadInOut')
		    end   
        
      
        end
    end]]

    function opponentNoteHit(id, direction, noteType, isSustainNote)
        local hp = getProperty('health')
        setProperty('health', hp - hp*0.01)
        cameraShake(game,0.005,0.1)
    end

   
end
function onStepHit()
	-- triggered 16 times per section
end
function onEndSong()
	if not allowCountdown and isStoryMode then --Block the first countdown
			startVideo('cutsceneending');
		
		
		allowCountdown = true;
		return Function_Stop;
	end
	return Function_Continue;
end