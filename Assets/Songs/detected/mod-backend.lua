print('LOADED TEMPLATE')

TEMPLATE = {}

-- Taro's janky "TEMPLATE 1" implementation for FNF
-- shoutouts to Kade for letting me do this

-- EASING EQUATIONS

---------------------------------------------------------------------------------------
----------------------DON'T TOUCH IT KIDDO---------------------------------------------
---------------------------------------------------------------------------------------
			
-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and http://code.google.com/p/tweener/ (jstweener javascript version)
--

--[[
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright © 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

-- For all easing functions:
-- t = elapsed time
-- b = begin
-- c = change == ending - beginning
-- d = duration (total time)

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin  = math.asin

function linear(t, b, c, d)
  return c * t / d + b
end

function inQuad(t, b, c, d)
  t = t / d
  return c * pow(t, 2) + b
end

function outQuad(t, b, c, d)
  t = t / d
  return -c * t * (t - 2) + b
end

function inOutQuad(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 2) + b
  else
    return -c / 2 * ((t - 1) * (t - 3) - 1) + b
  end
end

function outInQuad(t, b, c, d)
  if t < d / 2 then
    return outQuad (t * 2, b, c / 2, d)
  else
    return inQuad((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inCubic (t, b, c, d)
  t = t / d
  return c * pow(t, 3) + b
end

function outCubic(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 3) + 1) + b
end

function inOutCubic(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * t * t * t + b
  else
    t = t - 2
    return c / 2 * (t * t * t + 2) + b
  end
end

function outInCubic(t, b, c, d)
  if t < d / 2 then
    return outCubic(t * 2, b, c / 2, d)
  else
    return inCubic((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inQuart(t, b, c, d)
  t = t / d
  return c * pow(t, 4) + b
end

function outQuart(t, b, c, d)
  t = t / d - 1
  return -c * (pow(t, 4) - 1) + b
end

function inOutQuart(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 4) + b
  else
    t = t - 2
    return -c / 2 * (pow(t, 4) - 2) + b
  end
end

function outInQuart(t, b, c, d)
  if t < d / 2 then
    return outQuart(t * 2, b, c / 2, d)
  else
    return inQuart((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inQuint(t, b, c, d)
  t = t / d
  return c * pow(t, 5) + b
end

function outQuint(t, b, c, d)
  t = t / d - 1
  return c * (pow(t, 5) + 1) + b
end

function inOutQuint(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(t, 5) + b
  else
    t = t - 2
    return c / 2 * (pow(t, 5) + 2) + b
  end
end

function outInQuint(t, b, c, d)
  if t < d / 2 then
    return outQuint(t * 2, b, c / 2, d)
  else
    return inQuint((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inSine(t, b, c, d)
  return -c * cos(t / d * (pi / 2)) + c + b
end

function outSine(t, b, c, d)
  return c * sin(t / d * (pi / 2)) + b
end

function inOutSine(t, b, c, d)
  return -c / 2 * (cos(pi * t / d) - 1) + b
end

function outInSine(t, b, c, d)
  if t < d / 2 then
    return outSine(t * 2, b, c / 2, d)
  else
    return inSine((t * 2) -d, b + c / 2, c / 2, d)
  end
end

function inExpo(t, b, c, d)
  if t == 0 then
    return b
  else
    return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
  end
end

function outExpo(t, b, c, d)
  if t == d then
    return b + c
  else
    return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
  end
end

function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = t / d * 2
  if t < 1 then
    return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
  else
    t = t - 1
    return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
  end
end

function outInExpo(t, b, c, d)
  if t < d / 2 then
    return outExpo(t * 2, b, c / 2, d)
  else
    return inExpo((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inCirc(t, b, c, d)
  t = t / d
  return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
end

function outCirc(t, b, c, d)
  t = t / d - 1
  return(c * sqrt(1 - pow(t, 2)) + b)
end

function inOutCirc(t, b, c, d)
  t = t / d * 2
  if t < 1 then
    return -c / 2 * (sqrt(1 - t * t) - 1) + b
  else
    t = t - 2
    return c / 2 * (sqrt(1 - t * t) + 1) + b
  end
end

function outInCirc(t, b, c, d)
  if t < d / 2 then
    return outCirc(t * 2, b, c / 2, d)
  else
    return inCirc((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function inElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1  then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  t = t - 1

  return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
end

-- a: amplitud
-- p: period
function outElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d

  if t == 1 then return b + c end

  if not p then p = d * 0.3 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c/a)
  end

  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
end

-- p = period
-- a = amplitud
function inOutElastic(t, b, c, d, a, p)
  if t == 0 then return b end

  t = t / d * 2

  if t == 2 then return b + c end

  if not p then p = d * (0.3 * 1.5) end
  if not a then a = 0 end

  local s

  if not a or a < abs(c) then
    a = c
    s = p / 4
  else
    s = p / (2 * pi) * asin(c / a)
  end

  if t < 1 then
    t = t - 1
    return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
  else
    t = t - 1
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
  end
end

-- a: amplitud
-- p: period
function outInElastic(t, b, c, d, a, p)
  if t < d / 2 then
    return outElastic(t * 2, b, c / 2, d, a, p)
  else
    return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
  end
end

function inBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d
  return c * t * t * ((s + 1) * t - s) + b
end

function outBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  t = t / d - 1
  return c * (t * t * ((s + 1) * t + s) + 1) + b
end

function inOutBack(t, b, c, d, s)
  if not s then s = 1.70158 end
  s = s * 1.525
  t = t / d * 2
  if t < 1 then
    return c / 2 * (t * t * ((s + 1) * t - s)) + b
  else
    t = t - 2
    return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
  end
end

function outInBack(t, b, c, d, s)
  if t < d / 2 then
    return outBack(t * 2, b, c / 2, d, s)
  else
    return inBack((t * 2) - d, b + c / 2, c / 2, d, s)
  end
end

function outBounce(t, b, c, d)
  t = t / d
  if t < 1 / 2.75 then
    return c * (7.5625 * t * t) + b
  elseif t < 2 / 2.75 then
    t = t - (1.5 / 2.75)
    return c * (7.5625 * t * t + 0.75) + b
  elseif t < 2.5 / 2.75 then
    t = t - (2.25 / 2.75)
    return c * (7.5625 * t * t + 0.9375) + b
  else
    t = t - (2.625 / 2.75)
    return c * (7.5625 * t * t + 0.984375) + b
  end
end

function inBounce(t, b, c, d)
  return c - outBounce(d - t, 0, c, d) + b
end

function inOutBounce(t, b, c, d)
  if t < d / 2 then
    return inBounce(t * 2, 0, c, d) * 0.5 + b
  else
    return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
  end
end

function outInBounce(t, b, c, d)
  if t < d / 2 then
    return outBounce(t * 2, b, c / 2, d)
  else
    return inBounce((t * 2) - d, b + c / 2, c / 2, d)
  end
end

function scale(x, l1, h1, l2, h2)
	return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

function math.clamp(val,min,max)
	if val < min then return min end
	if val > max then return max end
	return val
end

---------------------------------------------------------------------------------------
----------------------END DON'T TOUCH IT KIDDO-----------------------------------------
---------------------------------------------------------------------------------------

beat = 0
ARROW_SIZE = 112

--all of our mods, with default values
modList = {
	beat = 0,
	flip = 0,
	invert = 0,
	drunk = 0,
	tipsy = 0,
	adrunk = 0, --non conflict accent mod
	atipsy = 0, --non conflict accent mod
	movex = 0,
	movey = 0,
	amovex = 0,
	amovey = 0,
	reverse = 0,
	split = 0,
	cross = 0,
	dark = 0,
	stealth = 0,
	alpha = 1,
	confusion = 0,
	dizzy = 0,
	wave = 0,
	brake = 0,
	hidden = 0,
	hiddenoffset = 0,
	alternate = 0,
	camx = 0,
	camy = 0,
	rotationz = 0,
	camwag = 0,
	xmod = 1, --scrollSpeed
	drawsize = 10 --beatcutoff
}

--column specific mods
for i=0,3 do
	modList['movex'..i] = 0
	modList['movey'..i] = 0
	modList['amovex'..i] = 0
	modList['amovey'..i] = 0
	modList['dark'..i] = 0
	modList['stealth'..i] = 0
	modList['confusion'..i] = 0
	modList['reverse'..i] = 0
	modList['xmod'..i] = 1 --column specific scrollSpeed multiplier
end

activeMods = {{},{}}

for pn=1,2 do
	for k,v in pairs(modList) do
		activeMods[pn][k] = v
	end
end

storedMods = {{},{}}
targetMods = {{},{}}
isTweening = {{},{}}
tweenStart = {{},{}}
tweenLen = {{},{}}
tweenCurve = {{},{}}
tweenEx1 = {{},{}}
tweenEx2 = {{},{}}
modnames = {}

function definemod(t)
	local k,v = t[1],t[2]
	if not v then v = 0 end
	for pn=1,2 do
		storedMods[pn][k] = v
		targetMods[pn][k] = v
		isTweening[pn][k] = false
		tweenStart[pn][k] = 0
		tweenLen[pn][k] = 0
		tweenCurve[pn][k] = linear
		tweenEx1[pn][k] = nil
		tweenEx2[pn][k] = nil
		if pn == 1 then
			--print('registered modifier: '..k)
			table.insert(modnames,k)
		end
	end
end

function TEMPLATE.InitMods()
	for pn=1,2 do
		for k,v in pairs(activeMods[pn]) do
			definemod{k,v}
		end
	end
end

function TEMPLATE.setup()
	--sort tables, optimization step
	function modtable_compare(a,b)
		return a[1] < b[1]
	end
	
	if table.getn(event) > 1 then
		table.sort(event, modtable_compare)
	end
	if table.getn(mods) > 1 then
		table.sort(mods, modtable_compare)
	end
end

function flicker()
	if (songPos * 0.001 * 60) % 2 < 1 then
		return -1
	else
		return 1
	end
end

function receptorAlpha(iCol,pn)
	local alp = 1
	
	local m = activeMods[pn]
	
	if m.alpha ~= 1 then
		alp = alp*m.alpha
	end
	if m.dark ~= 0 or m['dark'..iCol] ~= 0 then
		alp = alp*(1-m.dark)*(1-m['dark'..iCol])
	end
	
	return alp
end

function arrowAlpha(fYOffset, iCol,pn)
	local alp = 1
	
	local m = activeMods[pn]
	
	if m.alpha ~= 1 then
		alp = alp*m.alpha
	end
	if m.stealth ~= 0 or m['stealth'..iCol] ~= 0 then
		alp = alp*(1-m.stealth)*(1-m['stealth'..iCol])
	end
	if m.hidden ~= 0 then
		if fYOffset < m.hiddenoffset and fYOffset >= m.hiddenoffset-200 then
			local hmult = -(fYOffset-m.hiddenoffset)/200
			alp = alp*(1-hmult)*m.hidden
		elseif fYOffset < m.hiddenoffset-100 then
			alp = alp*(1-m.hidden)
		end
	end
	return alp
end

function getReverseForCol(iCol,pn)
	local m = activeMods[pn]
	local val = 0
	
	val = val+m.reverse+m['reverse'..iCol]
	
	if m.split ~= 0 and iCol > 1 then val = val+m.split end
	if m.cross ~= 0 and iCol == 1 or iCol == 2 then val = val+m.cross end
	if m.alternate ~= 0 and iCol % 2 == 1 then val = val+m.alternate end
	
	return val
end

function getYAdjust(fYOffset, iCol, pn)
	
	local m = activeMods[pn]
	
	local yadj = 0
	if m.wave ~= 0 then
		yadj = yadj + m.wave * 20*math.sin( (fYOffset+250)/76 )
	end
	
	if m.brake ~= 0 then

		local fEffectHeight = 500;
		local fScale = scale( fYOffset, 0, fEffectHeight, 0, 1 )
		local fNewYOffset = fYOffset * fScale; 
		local fBrakeYAdjust = m.brake * (fNewYOffset - fYOffset)
		
		fBrakeYAdjust = math.clamp( fBrakeYAdjust, -400, 400 )
		yadj = yadj+fBrakeYAdjust;
	
	end
	
	fYOffset = fYOffset+yadj
	
	return fYOffset
end

function arrowEffects(fYOffset, iCol, pn)
    
    local m = activeMods[pn]
	
    local xpos, ypos, rotz = 0, 0, 0
	
	if m['confusion'..iCol] ~= 0 or m.confusion ~= 0 then
		rotz = rotz + m['confusion'..iCol] + m.confusion
	end
	if m.dizzy ~= 0 then
		rotz = rotz + m.dizzy*fYOffset
	end
	
    if m.drunk ~= 0 then
        xpos = xpos + m.drunk * ( math.cos( songPos*0.001 + iCol*(0.2) + 1*(0.2) + fYOffset*(10)/720) * ARROW_SIZE*0.5 )
    end
    if m.tipsy ~= 0 then
        ypos = ypos + m.tipsy * ( math.cos( songPos*0.001 *(1.2) + iCol*(2.0) + 1*(0.2) ) * ARROW_SIZE*0.4 )
    end
    if m.adrunk ~= 0 then
        xpos = xpos + m.adrunk * ( math.cos( songPos*0.001 + iCol*(0.2) + 1*(0.2) + fYOffset*(10)/720) * ARROW_SIZE*0.5 )
    end
    if m.atipsy ~= 0 then
        ypos = ypos + m.atipsy * ( math.cos( songPos*0.001 *(1.2) + iCol*(2.0) + 1*(0.2) ) * ARROW_SIZE*0.4 )
    end
	
	if m['movex'..iCol] ~= 0 or m.movex ~= 0 then
		xpos = xpos + m['movex'..iCol] + m.movex
	end
	if m['amovex'..iCol] ~= 0 or m.amovex ~= 0 then
		xpos = xpos + m['amovex'..iCol] + m.amovex
	end
	if m['movey'..iCol] ~= 0 or m.movey ~= 0 then
		ypos = ypos + m['movey'..iCol] + m.movey
	end
	if m['amovey'..iCol] ~= 0 or m.amovey ~= 0 then
		ypos = ypos + m['amovey'..iCol] + m.amovey
	end
	
	if m['reverse'..iCol] ~= 0 or m.reverse ~= 0 or m.split ~= 0 or m.cross ~= 0 or m.alternate ~= 0 then
		ypos = ypos + getReverseForCol(iCol,pn) * 450
	end
	
	if m.flip ~= 0 then
		local fDistance = ARROW_SIZE * 2 * (1.5 - iCol);
		xpos = xpos + fDistance * m.flip;
	end

	if m.invert ~= 0 then
		local fDistance = ARROW_SIZE * (iCol%2 == 0 and 1 or -1);
		xpos = xpos + fDistance * m.invert;
	end
	
	if m.beat ~= 0 then
			
		local fBeatStrength = m.beat;
		
		local fAccelTime = 0.3;
		local fTotalTime = 0.7;
		
		-- If the song is really fast, slow down the rate, but speed up the
		-- acceleration to compensate or it'll look weird.
		fBeat = beat + fAccelTime;
		
		local bEvenBeat = false;
		if math.floor(fBeat) % 2 ~= 0 then
			bEvenBeat = true;
		end
		
		fBeat = fBeat-math.floor( fBeat );
		fBeat = fBeat+1;
		fBeat = fBeat-math.floor( fBeat );
		
		if fBeat<fTotalTime then
		
			local fAmount = 0;
			if fBeat < fAccelTime then
				fAmount = scale( fBeat, 0.0, fAccelTime, 0.0, 1.0);
				fAmount = fAmount*fAmount;
			else 
				--fBeat < fTotalTime
				fAmount = scale( fBeat, fAccelTime, fTotalTime, 1.0, 0.0);
				fAmount = 1 - (1-fAmount) * (1-fAmount);
			end

			if bEvenBeat then
				fAmount = fAmount*-1;
			end

			local fShift = 40.0*fAmount*math.sin( ((fYOffset/30.0)) + (math.pi/2) );
			
			xpos = xpos + fBeatStrength * fShift
			
		end
	
	end
	
    return xpos, ypos, rotz
    
end




defaultPositions = {{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0}}



-- events

mods,curmod = {},1
perframe = {}
event,curevent = {},1
songStarted = false

function me(t)
	table.insert(mods,t)
end

function m2(t)
	table.insert(event,t)
end

function mpf(t)
	table.insert(perframe,t)
end

function set(t)
	table.insert(mods,{t[1],0,linear,t[2],t[3],pn=t.pn})
end

function TEMPLATE.songStart(song)
    
    downscroll = false

	for i=0,7 do
        local receptor = _G['receptor_'..i]
        defaultPositions[i+1].x = receptor.x
        defaultPositions[i+1].y = receptor.y

        --print(i .. ": " .. defaultPositions[i+1].x .. " " .. defaultPositions[i+1].y)
    end
	
	--fuck it, it's mods. You don't get a say here.
	--(this is done to prevent a lot of bugs and weird cases)
	storedScrollSpeed = 1.8
	--storedScrollSpeed = scrollSpeed
	
	for pn=1,2 do
		activeMods[pn].xmod = storedScrollSpeed
	end
	
	songStarted = true
	
end

function TEMPLATE.update(elapsed)
    beat = (songPos / 1000) * (bpm/60)
    beatcutoff = activeMods[1].drawsize
	
	--------------------------------------------------------------
	-- modified version of exschwasion's template 1 ease reader
	-- format changed to make it more mirin-like
	-- v[1]=startBeat v[2]=len/end v[3]=curve v[4]=newval v[5]=modname, v.pn=player
	-- len is now implied, but v.timing='len' or v.timing='end' for specifics
	-- v.startVal for specifying new start val
	-- v.ex1, v.ex2 for the extra params of elastic and back eases
	--------------------------------------------------------------
	
	while curmod <= #mods and beat > mods[curmod][1] do
		local v = mods[curmod]
		
		local mn = v[5]
		local dur = v[2]
		if v.timing and v.timing == 'end' then
			dur = v[2]-v[1]
		end
		
		--print('launch attack '..mn..' at beat '..v[1])
		
		if v.plr and not v.pn then v.pn = v.plr end
		
		for pn=1,2 do
			if not v.pn or pn == v.pn then
				tweenStart[pn][mn] = v[1]
				tweenLen[pn][mn] = dur
				tweenCurve[pn][mn] = v[3]
				if v.startVal then
					storedMods[pn][mn] = v.startVal
				else
					storedMods[pn][mn] = activeMods[pn][mn]
				end
				targetMods[pn][mn] = v[4]
				tweenEx1[pn][mn] = v.ex1
				tweenEx2[pn][mn] = v.ex2
				isTweening[pn][mn] = true
			end
		end
		
		curmod = curmod+1
	end
	
	for pn=1,2 do
		for _,v in pairs(modnames) do
			
			if isTweening[pn][v] then
				local curtime = beat - tweenStart[pn][v]
				local duration = tweenLen[pn][v]
				local startstrength = storedMods[pn][v]
				local diff = targetMods[pn][v] - startstrength
				local curve = tweenCurve[pn][v]
				local strength = curve(curtime, startstrength, diff, duration, tweenEx1[pn][v], tweenEx2[pn][v])
				activeMods[pn][v] = strength
				if beat > tweenStart[pn][v]+duration then
					isTweening[pn][v] = false
				end
			else
				activeMods[pn][v] = targetMods[pn][v]
			end
			
		end
	end
	
	----------------------------------------
	-- do this stuff every frame --
	----------------------------------------
	if #perframe>0 then
		for i=1,#perframe do
			local a = perframe[i]
			if beat > a[1] and beat < a[2] then
				a[3](beat)
			end
		end
	end
	
	-----------------------------------------
	-- event queue --event,curevent = {},1 --
	-----------------------------------------
	while curevent <= #event and beat>=event[curevent][1] do
		if event[curevent][3] or beat < event[curevent][1]+2 then
			event[curevent][2]()
		end
		curevent = curevent+1;
	end
	
	---------------------------------------
	-- ACTUALLY APPLY THE RESULTS OF THE ABOVE CALCULATIONS TO THE NOTES
	---------------------------------------
	
	camNotes.angle = activeMods[1].rotationz + activeMods[1].camwag * math.sin(beat*math.pi)
	camNotes.x = activeMods[1].camx
	camNotes.y = activeMods[1].camy
	
	if songStarted then
		for pn=1,2 do
			local xmod = activeMods[pn].xmod
			for col=0,3 do
			
				local c = (pn-1)*4 + col
				local receptor = _G['receptor_'..c]
				
				--print('Areceptor '..c..' is '..tostring(receptor))
			
				local defaultx, defaulty = defaultPositions[c+1].x, defaultPositions[c+1].y
				
				local xp, yp, rz = arrowEffects(0, col, pn)
				local alp = receptorAlpha(col,pn)
				
				receptor.x = defaultx + xp
				receptor.y = defaulty + yp
				receptor.angle = rz
				receptor.alpha = alp
				
				local scrollSpeed = xmod * activeMods[pn]['xmod'..col] * (1 - 2*getReverseForCol(col,pn))
				setLaneScrollspeed(c, scrollSpeed)
				
				--print('Breceptor '..c..' is '..tostring(receptor))
				
			end
		end
		
		--for i=1,getNumberOfNotes() do
		--	local note = _G['note_'..i]
		for i, v in ipairs(getNotes()) do
			local note = _G[v]
			
			if not note.isDead then
				
				--print(tostring(note)..' sus '..tostring(note.isSustain))
				
				local pn = 1
				if note.mustPress then pn = 2 end
				
				
				local xmod = activeMods[pn].xmod
				
				local isSus = note.isSustain
				local isParent = note.isParent
				local col = note.data
				local c = (pn-1)*4 + col
				
				local targTime = note.strumTime
				
				local defaultx, defaulty = defaultPositions[c+1].x, defaultPositions[c+1].y
				
				local scrollSpeed = xmod * activeMods[pn]['xmod'..col] * (1 - 2*getReverseForCol(col,pn))
				
				local off = note.yNoteOff * (1 - 2*getReverseForCol(col,pn))

				local ypos = getYAdjust(defaulty - (songPos - targTime),col,pn) * scrollSpeed * 0.45 - off
				
				local xa, ya, rz = arrowEffects(ypos-defaulty, col, pn)
				local alp = arrowAlpha(ypos-defaulty, col, pn)
				
				if note.isSustain and not note.isParent then
					local ypos2 = getYAdjust(defaulty - ((songPos+.1) - targTime),col,pn) * scrollSpeed * 0.45 - off
					local xa2, ya2 = arrowEffects(ypos2-defaulty, col, pn)
					--if scrollSpeed >= 0 then
						note.angle = math.deg(math.atan2(((ypos2 + ya2)-(ypos + ya))*100,(xa2-xa)*100) + math.pi/2)
					--else
					--	note.angle = 180+math.deg(math.atan2(((ypos2 + ya2)-(ypos + ya))*100,(xa2-xa)*100) + math.pi/2)
					--end
				else
					note.angle = rz
				end
				
				note.x = defaultx + xa
				note.y = ypos + ya
				note.alpha = alp
				
				
			end
			
		end
		
	end
	
	
end

return 0