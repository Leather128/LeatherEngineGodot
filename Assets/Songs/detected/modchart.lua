--Taro template \o/

function start(song)
	
	dofile("assets/data/songs/detected/mod-backend.lua")
	TEMPLATE.InitMods()
	
	
	
	--WRITE MODS HERE! 
	
	local disable = false
	
	local ALLOW_REVERSE = true


	
	--some basic helpers
	function hide(t)
		local bt,tpn = t[1],t.pn
		for i=0,3 do
			me{bt+i*.125-1,.5,outExpo,-70,'movey'..i,pn=tpn}
			me{bt+i*.125-.5,1.25,inExpo,650,'movey'..i,pn=tpn}
			set{bt+i*.125+1.75,1,'stealth',pn=tpn}
			set{bt+i*.125+1.75,1,'dark',pn=tpn}
		end
	end
	function unhide(t)
		local bt,tpn = t[1],t.pn
		for i=0,3 do
			set{bt+i*.125-2,0,'stealth',pn=tpn}
			set{bt+i*.125-2,0,'dark',pn=tpn}
			me{bt+i*.125-2,1,outExpo,-70,'movey'..i,pn=tpn}
			me{bt+i*.125-1,1,inExpo,50,'movey'..i,pn=tpn}
			me{bt+i*.125-0,1.25,outElastic,0,'movey'..i,pn=tpn}
		end
	end
	--wiggle(beat,num,div,ease,amt,mod)
	function wig(t)
		local b,num,div,ea,am,mo = t[1],t[2],t[3],t[4],t[5],t[6]
		local f = 1
		for i=0,num do
			local smul = i==0 and 1 or 0
			local emul = i==num and 0 or 1
			
			me{b+i*(1/div),1/div,ea,startVal = am*smul*f, am*emul*-f,mo,pn=t.pn}
			
			f = f*-1
		end
	end
	--simple mod 2
	local function sm2(tab)
		local b,len,eas,amt,mods,intime = tab[1],tab[2],tab[3],tab[4],tab[5],tab.intime
		if not intime then intime = .1 end
		if intime <= 0 then intime = .001 end
		me{b-intime,intime,linear,amt,mods,pn=tab.pn}
		me{b,len-intime,eas,0,mods,pn=tab.pn}
	end
	
		definemod{'colspacing',112}
		definemod{'spacing',620}
		definemod{'addx',0}
		definemod{'waveamp',0}
		
		definemod{'halo',0}
		
	
	
	
	
	
	set{0,1.8,'xmod'}
	set{0,32,'drawsize'}
	
	if not disable then
		me{0,4,outCubic,2,'tipsy',pn=1}
		me{12,4,inCubic,1,'tipsy',pn=1}
		
		me{16,4,outCubic,1,'tipsy',pn=2}
		me{28,4,inCubic,0,'tipsy'}
		
		
		
		--kade "sway"
		mpf{32,64,function(beat)
			
			local pn = 1
			
			if beat > 48 then
				pn = 2
			end
			
			for col = 0,3 do
				activeMods[pn]['movex'..col] = 32 * math.sin((beat + col*0.25) * math.pi)
				local mu = col%2 == 0 and 1 or -1
				activeMods[pn]['movey'..col] = 32 * mu * math.tan((beat) * 0.25 * math.pi)
			end
			
		end}
		
		local f = 1
		for i=32,63,4 do
			--spinny
			local spn = 1
			if i >= 48 then
				spn = 2
			end
			me{i,2,outCubic,startVal=360*f,0,'confusion',pn=spn}
			f = f*-1
		end
		
		
		
		me{62,4,inOutCubic,.4,'alpha',pn=1}
		me{94,4,inOutCubic,1,'alpha',pn=1}
		
		set{91.5,3,'beat'}
		set{95.5,0,'beat'}
		
		
		--NEW wrapping
		--WITHOUT FLICKER
		me{64,8,inOutCubic,1280/8,'colspacing'}
		me{64,8,inOutCubic,(1280/8)*4,'spacing'}
		me{64,8,inOutCubic,-176,'addx'}
		me{64,8,inOutCubic,1,'waveamp'}
		
		me{92,4,inCubic,112,'colspacing'}
		me{92,4,inCubic,620,'spacing'}
		me{92,4,inCubic,0,'addx'}
		me{92,4,inCubic,0,'waveamp'}
		
		mpf{64,95,function(beat)
			
			local scrollerpos = beat-64
			
			for pn=1,2 do
			
				for col = 0,3 do
					local cpos = col*-112
					if pn == 2 then cpos = cpos-620 end
					local c = (pn-1)*4+col
					
					local colspacing = activeMods[pn].colspacing
					local spacing = activeMods[pn].spacing
					local addx = activeMods[pn].addx
					local waveamp = activeMods[pn].waveamp
					
					local newpos = (col*colspacing + (pn-1)*spacing + scrollerpos*1280/8)%1280 + addx
					
					activeMods[pn]['movex'..col] = cpos + newpos
				
					local ang = 2*math.pi*(c/8)
					activeMods[pn]['reverse'..col] = waveamp * .1 * math.sin(beat*math.pi + ang)
					
				end
				
			end
			
		end}
		
		
		local wso = 0
		
		hide{(96-wso)-1,pn=2}
		unhide{(96-wso)+16,pn=2}
		hide{(96-wso)+16,pn=1}
		unhide{(96-wso)+32,pn=1}
		hide{(96-wso)+32,pn=2}
		unhide{(96-wso)+48,pn=2}
		hide{(96-wso)+48,pn=1}
		unhide{(96-wso)+64,pn=1}
		
		me{(96-wso)-3,3,linear,1.6,'xmod'}
		--me{(96-wso)-3,3,linear,1,'drunk'}
		--set{(96-wso)-3,1,'drunk'}
		
		me{(96-wso)-4,3,linear,50,'movey'}
		me{(96-wso),3,linear,-.1,'flip'}
		
		me{(96-wso)+28,4,inCubic,0,'flip'}
		
		for i=0,1 do
			me{(96-wso)+8*i,4,linear,448*1.2,'movex',pn=1}
			me{(96-wso)+4+8*i,4,linear,0,'movex',pn=1}
			me{(96-wso)+16+8*i,4,linear,-448*1.2,'movex',pn=2}
			me{(96-wso)+16+4+8*i,4,linear,0,'movex',pn=2}
		end
		
		mpf{(96-wso),(96-wso)+64,function(beat)
			
			local pn=1
			if (beat-(96-wso)) % 32 > 16 then pn = 2 end
			
			local pingpong = beat - math.floor(beat)
			if beat%2 > 1 then
				pingpong = 1-pingpong
			end
			
			local wdir = -1 * (pn*2-3)
			if (beat-(96-wso)) % 8 > 4 then wdir = wdir*-1 end
			
			if beat < (96-wso)+32 then
				for col=0,3 do
					activeMods[pn]['amovey'..col] = math.min(-112 * wdir * math.sin(beat*math.pi + col*math.pi),0)
				end
				activeMods[pn].invert = pingpong*1.2
			else
				for col=0,3 do
					activeMods[pn]['amovey'..col] = -56*1.2 * wdir * math.sin(beat*math.pi + col*math.pi)
				end
				activeMods[pn].invert = 0.6 - 0.6*math.cos(beat*math.pi)
			end
			
		end}
		
		
		local kick = {
			{208.000,0,1},
			{208.750,0,1},
			{209.500,0,1},
			{210.250,0,1},
			{211.000,3,1},
			{211.500,3,1},
			{212.000,0,1},
			{212.750,0,1},
			{213.500,0,1},
			{214.250,0,1},
			{215.000,3,1},
			{215.500,3,1},
			{216.000,0,1},
			{216.750,0,1},
			{217.500,0,1},
			{218.250,0,1},
			{219.000,3,1},
			{219.500,3,1},
		}
		
		for pn=1,2 do
			local f1 = 1
			local f2 = 1
			for _,v in pairs(kick) do
				if v[2] == 0 then
					me{v[1],.75,outCubic,startVal=2*f1*(pn*2-3),0,'adrunk',plr=pn}
					f1 = f1*-1
				else
					me{v[1],.75,outCubic,startVal=2*f2*(pn*2-3),0,'atipsy',plr=pn}
					f2 = f2*-1
				end
			end
		end
		
		local ddo = 0
		
		me{160-ddo-3,3,inOutCubic,1.4,'xmod'}
		set{160-ddo-.3,2,'beat'}
		set{208-ddo-.7,0,'beat'}

		me{160-ddo-2,4,inOutCubic,.2,'alpha',pn=1}
		me{208-ddo-2,4,inOutCubic,.5,'alpha',pn=1}
		me{219-ddo,2,inOutCubic,1,'alpha',pn=1}
		me{223-ddo,2,inOutCubic,.5,'alpha',pn=1}
		
		for pn=1,2 do
			me{160-ddo-2,4,inOutCubic,-310*(pn*2-3),'amovex',plr=pn}
			me{208-ddo-2,2,inCubic,0,'amovex',plr=pn}
			me{208-ddo,12,linear,-310*(pn*2-3),'amovex',plr=pn}
		end
		
		for i=160-ddo,208-ddo-1 do
			me{i,1,linear,1.7*112,startVal=0,'amovey'}
		end
		set{208-ddo,0,'amovey'}
		
		me{174-ddo,4,inOutCubic,180,'rotationz'}
		me{174-ddo,4,inOutCubic,-560,'camy'}
		me{190-ddo,4,inOutCubic,90,'rotationz'}
		me{190-ddo,4,inOutCubic,-280,'camy'}
		me{206-ddo,4,inOutCubic,0,'rotationz'}
		me{206-ddo,4,inOutCubic,0,'camy'}
		
		me{174-ddo,4,inOutCubic,-180,'confusion'}
		me{190-ddo,4,inOutCubic,-90,'confusion'}
		me{206-ddo,4,inOutCubic,0,'confusion'}
		
		me{174-ddo,4,inOutCubic,1,'flip'}
		me{190-ddo,4,inOutCubic,0,'flip'}
		
		me{216,4,linear,0,'alpha',pn=2}
		
		wig{220,16,4,outCubic,1,'drunk',pn=1}
		
		
		set{224,1,'alpha',pn=2}
		set{224,0,'stealth',pn=2}
		set{224,1,'dark',pn=2}
		me{234,3,linear,0,'dark',pn=2}
		
		
		
		local pieo = 0
		me{224-pieo,28,linear,3,'wave'}
		me{224-pieo,8,linear,1,'hidden'}
		set{224-pieo,50,'hiddenoffset'}
		me{240-pieo,12,linear,400,'hiddenoffset'}
		me{252-pieo,8,inOutCubic,2,'wave'}
		me{252-pieo,8,inOutCubic,.5,'drunk'}
		me{252-pieo,8,inOutCubic,200,'hiddenoffset'}
		
		for pn=1,2 do
			set{224-pieo,-310*(pn*2-3),'amovex',pn=pn}
		end
		set{224-pieo,.3,'alpha',pn=1}
		
		--kade "sway" again
		mpf{256-pieo,284-pieo,function(beat)
			
			for pn=1,2 do
				for col = 0,3 do
					activeMods[pn]['movex'..col] = 32 * math.sin((beat + col*0.25) * math.pi)
					local mu = col%2 == 0 and 1 or -1
					activeMods[pn]['movey'..col] = 32 * mu * math.tan((beat) * 0.25 * math.pi)
				end
			end
			
		end}
		
		me{280-pieo,8,inOutCubic,0,'wave'}
		me{280-pieo,8,inOutCubic,0,'drunk'}
		me{276-pieo,8,inOutCubic,0,'hidden'}
		set{288,0,'hiddenoffset'}
		
		local f = 1
		for i=256-pieo,283-pieo,4 do
			for pn = 1,2 do
				me{i,2,outCubic,startVal=360*f,0,'confusion',pn=spn}
			end
			f = f*-1
		end
		
		for pn=1,2 do
			me{284-pieo,4,inCubic,0,'amovex',plr=pn}
		end
		
		--NEW wrapping?
		--WITH NO FLICKER
		
		local fwo = 0
		
		me{288-fwo,8,inOutCubic,1280/8,'colspacing'}
		me{288-fwo,8,inOutCubic,(1280/8)*4,'spacing'}
		me{288-fwo,8,inOutCubic,-176,'addx'}
		me{288-fwo,8,inOutCubic,1,'waveamp'}
		
		me{316-fwo,4,inCubic,112,'colspacing'}
		me{316-fwo,4,inCubic,620,'spacing'}
		me{316-fwo,4,inCubic,0,'addx'}
		me{316-fwo,4,inCubic,0,'waveamp'}
		
		mpf{288-fwo,320-fwo,function(beat)
			
			local scrollerpos = beat-(288-fwo)
			
			for pn=1,2 do
			
				for col = 0,3 do
					local cpos = col*-112
					if pn == 2 then cpos = cpos-620 end
					local c = (pn-1)*4+col
					
					local colspacing = activeMods[pn].colspacing
					local spacing = activeMods[pn].spacing
					local addx = activeMods[pn].addx
					local waveamp = activeMods[pn].waveamp
					
					local newpos = (col*colspacing + (pn-1)*spacing + scrollerpos*1280/8)%1280 + addx
					
					activeMods[pn]['movex'..col] = cpos + newpos
				
					local ang = 2*math.pi*(c/8)
					activeMods[pn]['reverse'..col] = waveamp * .1 * math.sin(beat*math.pi + ang)
					
				end
				
			end
			
		end}
		
		
		--[[
		me{288-fwo,8,outExpo,startVal=620,448,'spacing'}
		me{288-fwo,8,outExpo,startVal=0,224,'addx'}
		me{288-fwo,8,outExpo,startVal=0,1,'waveamp'}
		
		me{316-fwo,4,inCubic,0,'addx'}
		me{316-fwo,4,inCubic,0,'waveamp'}
		me{316-fwo,4,inCubic,620,'spacing'}
		
		mpf{288-fwo,320-fwo,function(beat)
			
			local f = flicker()
			if f == -1 then f = 0 end
			
			local scrollerpos = beat-288 
			
			for pn=1,2 do
				local cpos = 0
				if pn == 2 then cpos = -620 end
				
				local spacing = activeMods[pn].spacing
				local addx = activeMods[pn].addx
				local waveamp = activeMods[pn].waveamp
				
				local newpos = (spacing * (pn - 1 + f*2) + scrollerpos * spacing * 0.25)%(spacing*4) - spacing*2 + addx
				
				activeMods[pn].movex = cpos + newpos
				for col = 0,3 do
					local ang = 2*math.pi*((pn-1)*4 + col)/8
					activeMods[pn]['reverse'..col] = waveamp * .1 * math.sin(beat*math.pi + ang)
				end
				
			end
			
		end}
		]]
		
		set{315.5,3,'beat'}
		set{319.5,0,'beat'}
		
		
		
		
		local wso2 = 0
		
		hide{(320-wso2)-1,pn=2}
		unhide{(320-wso2)+16,pn=2}
		hide{(320-wso2)+16,pn=1}
		unhide{(320-wso2)+32,pn=1}
		
		me{(320-wso2)-3,3,linear,1.7,'xmod'}
		--me{(320-wso2)-3,3,linear,1,'drunk'}
		--set{(320-wso2)-3,1,'drunk'}
		
		me{(320-wso2)-2,2,linear,1,'alpha',pn=1}
		
		me{(320-wso2)-4,3,linear,50,'movey'}
		me{(320-wso2),3,linear,-.1,'flip'}
		
		me{(320-wso2)+28,4,inCubic,0,'flip'}
		
		for i=0,1 do
			me{(320-wso2)+8*i,4,linear,448*1.2,'movex',pn=1}
			me{(320-wso2)+4+8*i,4,linear,0,'movex',pn=1}
			me{(320-wso2)+16+8*i,4,linear,-448*1.2,'movex',pn=2}
			me{(320-wso2)+16+4+8*i,4,linear,0,'movex',pn=2}
		end
		
		mpf{(320-wso2),(320-wso2)+64,function(beat)
			
			local pn=1
			if (beat-(320-wso2)) % 32 > 16 then pn = 2 end
			
			local pingpong = beat - math.floor(beat)
			if beat%2 > 1 then
				pingpong = 1-pingpong
			end
			
			local wdir = -1 * (pn*2-3)
			if (beat-(320-wso2)) % 8 > 4 then wdir = wdir*-1 end
			
			if beat < (320-wso2)+32 then
				for col=0,3 do
					activeMods[pn]['amovey'..col] = math.min(-112 * wdir * math.sin(beat*math.pi + col*math.pi),0)
				end
				activeMods[pn].invert = pingpong*1.2
			else
				for col=0,3 do
					activeMods[pn]['amovey'..col] = -56*1.2 * wdir * math.sin(beat*math.pi + col*math.pi)
				end
				activeMods[pn].invert = 0.6 - 0.6*math.cos(beat*math.pi)
			end
			
		end}
		
		for i=320-wso2,351-wso2,8 do
			local plr = 2
			if (i-(320-wso2)) % 32 < 16 then plr = 1 end
			if ALLOW_REVERSE then
				me{i+3,2,inOutExpo,1,'reverse',pn=plr}
				me{i+7,2,inOutExpo,0,'reverse',pn=plr}
			end
		end
		
		local bso = 0
		
		me{352-bso-1,2,linear,.5,'alpha',pn=1}
		
		--sm2 = b,len,eas,amt,mods,intime
		for i=352-bso,383-bso,4 do
		
			sm2{i,2,outCubic,2,'drunk'}
			sm2{i,2,outCubic,1,'brake'}
			
			for pn=1,2 do
			
				me{i+1,1,inOutExpo,-310*(pn*2-3),'amovex',plr=pn}
				if i ~= 380-bso then
					me{i+1,1,inOutCubic,1,'invert',plr=pn}
					me{i+2.5,1,inOutExpo,0,'amovex',plr=pn}
					me{i+2.5,1,inOutCubic,0,'invert',plr=pn}
					
					for c=0,3 do
						local mu = c%2 == 0 and 1 or -1
						me{i+1,.5,outCubic,.1*mu,'reverse'..c,plr=pn}
						me{i+1.5,.5,inCubic,0,'reverse'..c,plr=pn}
						
						me{i+2.5,.5,outCubic,-.1*mu,'reverse'..c,plr=pn}
						me{i+3,.5,inCubic,0,'reverse'..c,plr=pn}
					end
				end
				
			end
		end
		
		
		local ddo2 = 0
			
		me{384-ddo2-3,3,inOutCubic,1.4,'xmod'}
		set{384-ddo2-.3,2,'beat'}
		set{416-ddo2-.7,0,'beat'}

		me{384-ddo2-2,4,inOutCubic,.25,'alpha',pn=1}
		me{416-ddo2-2,4,inOutCubic,.45,'alpha',pn=1}
		
		for pn=1,2 do
			set{384-ddo2,-310*(pn*2-3),'amovex',pn=pn}
			me{416-ddo2-2,2,inCubic,0,'amovex',pn=pn}
			me{428-ddo2,12,linear,-310*(pn*2-3),'amovex',pn=pn}
		end
		
		for i=384-ddo2,416-ddo2-1 do
			me{i,1,linear,1.7*112,startVal=0,'amovey'}
		end
		set{416-ddo2,0,'amovey'}
		
		set{384-ddo2,8,'camwag'}
		me{414-ddo2,2,linear,0,'camwag'}
		
		me{391-ddo2,2,inOutCubic,180,'rotationz'}
		me{391-ddo2,2,inOutCubic,-560,'camy'}
		
		me{399-ddo2,2,inOutCubic,0,'rotationz'}
		me{399-ddo2,2,inOutCubic,0,'camy'}
		
		me{407-ddo2,2,inOutCubic,-90,'rotationz'}
		me{407-ddo2,2,inOutCubic,-280,'camy'}
		
		me{415-ddo2,2,inOutCubic,0,'rotationz'}
		me{415-ddo2,2,inOutCubic,0,'camy'}
		
		me{391-ddo2,2,inOutCubic,-180,'confusion'}
		me{399-ddo2,2,inOutCubic,0,'confusion'}
		me{407-ddo2,2,inOutCubic,90,'confusion'}
		me{415-ddo2,2,inOutCubic,0,'confusion'}
		
		me{391-ddo2,2,inOutCubic,1,'flip'}
		me{399-ddo2,2,inOutCubic,0,'flip'}
		
		me{415-ddo2,2,inOutCubic,1.7,'xmod'}
		me{436-ddo2,8,linear,0,'alpha',plr=1}
		me{448-ddo2,2,linear,.3,'alpha',plr=1}
		
		
		wig{440-ddo2,16,4,outCubic,1,'drunk'}
		wig{444-ddo2,16,4,outCubic,2,'drunk'}
		
		set{416-ddo2,32,'drawsize'}
		
		if ALLOW_REVERSE then
			for i=0,1 do
				me{416+8*i-ddo2,4,linear,1,'reverse'}
				me{420+8*i-ddo2,4,linear,0,'reverse'}
				me{432+4*i-ddo2,2,linear,1,'reverse'}
				me{434+4*i-ddo2,2,linear,0,'reverse'}
			end
		end
		
		set{448-ddo2,32,'drawsize'}
		
		kick2 = {
			{416.000,0,1},
			{416.750,0,1},
			{417.500,0,1},
			{418.250,0,1},
			{419.000,3,1},
			{419.500,3,1},
			{420.000,0,1},
			{420.750,0,1},
			{421.500,0,1},
			{422.250,0,1},
			{423.000,3,1},
			{423.500,3,1},
			{424.000,0,1},
			{424.750,0,1},
			{425.500,0,1},
			{426.250,0,1},
			{427.000,3,1},
			{427.500,3,1},
			{428.000,0,1},
			{428.750,0,1},
			{429.500,0,1},
			{430.250,0,1},
			{431.000,3,1},
			{431.500,3,1},
			{432.000,0,1},
			{432.500,0,1},
			{433.000,0,1},
			{433.500,0,1},
			{434.000,0,1},
			{434.500,0,1},
			{435.000,0,1},
			{435.500,0,1},
			{436.000,0,1},
			{436.500,0,1},
			{437.000,0,1},
			{437.500,0,1},
			{438.000,0,1},
			{438.500,0,1},
			{439.000,0,1},
			{439.500,0,1},
		}
		
		for pn=1,2 do
			local f1 = 1
			local f2 = 1
			for _,v in pairs(kick2) do
				if v[2] == 0 then
					me{v[1]-ddo2,.75,outCubic,startVal=2*f1*(pn*2-3),0,'adrunk',plr=pn}
					f1 = f1*-1
				else
					me{v[1]-ddo2,.75,outCubic,startVal=2*f2*(pn*2-3),0,'atipsy',plr=pn}
					f2 = f2*-1
				end
			end
		end
		
		
		--NEW wrapping?
		--NO FLICKER
		
		local fwo2 = 0
		
		set{448-fwo2,.4,'alpha',pn=1}
		set{448-fwo2,32,'drawsize'}
		me{472-fwo2,4,inExpo,.5,'flip'}
		
		for pn=1,2 do
			set{448-fwo2,0,'amovex',pn=pn}
			set{476-fwo2,-310*(pn*2-3),'amovex',pn=pn}
		end
		
		me{448-fwo2,4,outCubic,startVal=112,1280/8,'colspacing'}
		--me{448-fwo2,8,inOutCubic,startVal=0,0,'colspacing'}
		me{448-fwo2,4,outCubic,startVal=0,(1280/8)*4,'spacing'}
		me{448-fwo2,4,outCubic,startVal=310,-176,'addx'}
		me{448-fwo2,8,inOutCubic,1,'waveamp'}
		
		me{472-fwo2,4,inCubic,112,'colspacing'}
		me{472-fwo2,4,inCubic,0,'spacing'}
		me{472-fwo2,4,inCubic,-310,'addx'}
		me{472-fwo2,4,inCubic,0,'waveamp'}
		
		mpf{448-fwo2,476-fwo2,function(beat)
			
			local scrollerpos = beat-(448-fwo2)
			
			for pn=1,2 do
			
				for col = 0,3 do
					local cpos = col*-112 + 0
					if pn == 2 then cpos = cpos-620 end
					local c = (pn-1)*4+col
					
					local colspacing = activeMods[pn].colspacing
					local spacing = activeMods[pn].spacing
					local addx = activeMods[pn].addx
					local waveamp = activeMods[pn].waveamp
					
					local newpos = (col*colspacing + (pn-1)*spacing + scrollerpos*1280/8)%1280 + addx
					
					activeMods[pn]['movex'..col] = cpos + newpos
				
					local ang = 2*math.pi*(c/8)
					activeMods[pn]['reverse'..col] = waveamp * .1 * math.sin(beat*math.pi + ang)
					
				end
				
			end
			
		end}
		
		if ALLOW_REVERSE then
			for i=448-fwo2,463-fwo2,8 do
				me{i+3,2,inOutCubic,1,'reverse'}
				me{i+7,2,inOutCubic,0,'reverse'}
			end
			for i=464-fwo2,471-fwo2,4 do
				me{i+1.5,1,inOutCubic,1,'reverse'}
				me{i+3.5,1,inOutCubic,0,'reverse'}
			end
		end
		
		me{475-fwo2,2,linear,1,'alpha',plr=1}
		me{476-fwo2,8,outExpo,1,'halo'}
		
		mpf{476-fwo2,488-fwo2,function(beat)
			
			for pn=1,2 do
			
				local halo = activeMods[pn].halo
				
				for col=0,3 do
					
					local ang = 2*math.pi*((pn-1)*4 + col)/8 + ((beat-476)*0.5*math.pi)
					
					activeMods[pn]['movex'..col] = 280 * halo * math.sin(ang)
					activeMods[pn]['movey'..col] = 70 * (1-(activeMods[pn].amovey/300)) * halo * math.cos(ang)
					
				end
				
			end
			
		end}
		
		me{484-fwo2,4,inCubic,750,'amovey'}
		
		
		
		
	end
		
	--me{0,4,inOutCubic,1,'reverse'}
	
	
	--must be called at END of start
	TEMPLATE.setup()
	
end

function songStart(song)
    
    TEMPLATE.songStart(song)
	
	--for i=0,7,1 do
	--	print('default position '..i..' = '..defaultPositions[i+1].x)
	--end
	
end

function update(elapsed)
    
	TEMPLATE.update(elapsed)
	
end
