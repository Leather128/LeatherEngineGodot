
local xx = 520;
local yy = 530;
local xx2 = 820;
local yy2 = 530;
local ofs = 30;
local followchars = true;
local del = 0;
local del2 = 0;


function onUpdate()
	if del > 0 then
		del = del - 1
	end
	if del2 > 0 then
		del2 = del2 - 1
	end
    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else

            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    else
        triggerEvent('Camera Follow Pos','','')
    end
    
end

function onStepHit()
    if curStep == 380 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 764 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 800 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 816 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 832 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 848 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 866 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 874 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 882 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 890 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 910 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 926 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 942 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 958 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 968 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 976 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 986 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 992 then
        characterPlayAnim('gf', 'cheer', 'true')
    end
    if curStep == 1008 then
        characterPlayAnim('gf', 'cheer', 'true')
    end

end