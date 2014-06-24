--THIS IS THE LUA FILE THAT HOLDS ALL STUFF RELATED TO THE GAME OBJECT -dylan
--A game object sets up and maintains an actual game.  It handles things 
--like players and some timekeeping.

--Create the Game object class
Game = {}
Game.__index = Game
	
function Game.new(self)
	local self = setmetatable({}, Game)
	self.gametime=0
	--number of cycles elapsed in game; for timekeeping
		
	--Instantiate the first players
	mainplayer = Player.new(mainplayer, "mainplayer", 4, 4, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))
	mainplayer.control="human"
	cpu1 = Player.new(cpu1, "cpu1", 20, 21, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))
	tony = Player.new(cpu1, "tony", 30, 8, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))
		
	--Load sounds
	turfsound = love.audio.newSource("turfsound.wav", "static")
	stealsound = love.audio.newSource("stealsound.wav", "static")
	enemysound = love.audio.newSource("enemysound.wav", "static")
		
		
	return self
end
	
function Game.DrawEvent()	
	--shade in all the colors from ColorGrid
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 255 )
			-- make human player's boxes flash
			if (math.ceil(maingame.gametime/40)-math.floor((maingame.gametime-10)/40)==2 and OwnerGrid[i][j]=="mainplayer") then 
				love.graphics.setColor( (ColorGrid[i][j][0]+3*255)/4, (ColorGrid[i][j][1]+3*255)/4, (ColorGrid[i][j][2]+3*255)/4, 255 )
			end
			-- draw box colors
			love.graphics.rectangle("fill", i*16, j*16, 16, 16 )
		end
	end
	
	--DRAW LOOP THAT APPLIES TO ALL PLAYERS
	for k = 0, PlayerNumber do
		-- draw the borders for every player	
		love.graphics.setColor(0,0,0, 255 )
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==0 or (i>0 and OwnerGrid[i-1][j]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==xblocks-1 or (i<xblocks-1 and OwnerGrid[i+1][j]~=PlayerList[k].name))) then love.graphics.line(i*16+16,j*16,i*16+16,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==0 or (j>0 and OwnerGrid[i][j-1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16+16,j*16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==yblocks-1 or (j<yblocks-1 and OwnerGrid[i][j+1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16+16,i*16+16,j*16+16) end
			end
		end
	end
	
	--DIAGNOSTIC TOOL! Displays territory owner over the block with mouse press
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (math.floor(love.mouse.getX()/16)==i and math.floor(love.mouse.getY()/16)==j ) then 
				love.graphics.setColor(255, 255, 255, 128)
				--love.graphics.print(OwnerGrid[i][j],i*16-8,j*16-16)
				love.graphics.print(mainplayer.MarginalBenefit(mainplayer,i,j),i*16,j*16-8)
			end	
		end
	end
end

function Game.UpdateEvent()

	--timekeeping
	maingame.gametime=maingame.gametime+1
	-- helps with mouse referencing; gives block indices for mouse
	mouse_x = math.floor(love.mouse.getX()/16)
	mouse_y = math.floor(love.mouse.getY()/16)
	
		--UPKEEP LOOP THAT APPLIES TO ALL PLAYERS
	for i = 0, PlayerNumber do
		if (PlayerList[i].grabtime<steal_delay) then PlayerList[i].grabtime=PlayerList[i].grabtime+1 end
		
		if (PlayerList[i]~=mainplayer and PlayerList[i].grabtime>=grab_delay) then
			PlayerList[i].explore(PlayerList[i],false)
			love.audio.play(enemysound)
			PlayerList[i].grabtime=0
		end
	
		if (PlayerList[i]~=mainplayer and PlayerList[i].grabtime>=steal_delay) then
			PlayerList[i].explore(PlayerList[i],true)
			love.audio.play(enemysound)
			PlayerList[i].grabtime=0
		end
	end
 
 	--routine for main player grabbing new tiles
	if (love.mouse.isDown("l")==true) then 
		if (mainplayer.grabtime>=grab_delay and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]=="nobody") then
			mainplayer.acquire(mainplayer,mouse_x,mouse_y)
			mainplayer.grabtime=0
			love.audio.play(turfsound)
		end
		if (mainplayer.grabtime==steal_delay and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]~="nobody" and OwnerGrid[mouse_x][mouse_y]~="mainplayer") then
			mainplayer.acquire(mainplayer,mouse_x,mouse_y)
			mainplayer.grabtime=0
			love.audio.play(stealsound)
		end
	end
	
		-- random cell color-changing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (OwnerGrid[i][j]~="nobody") then
				ColorGrid[i][j][0] = ColorGrid[i][j][0] + love.math.random(-1,1)
				ColorGrid[i][j][1] = ColorGrid[i][j][1] + love.math.random(-1,1)
				ColorGrid[i][j][2] = ColorGrid[i][j][2] + love.math.random(-1,1)
				ColorGrid[i][j][0] = math.min(math.abs(ColorGrid[i][j][0]),255)
				ColorGrid[i][j][1] = math.min(math.abs(ColorGrid[i][j][1]),255)
				ColorGrid[i][j][2] = math.min(math.abs(ColorGrid[i][j][2]),255)			
			end
		end
	end
	
	function Game.GetLandTotal (self) --function to determine how much land is controlled by players in total
		local counter=0
		for i=0, xblocks-1 do
			for j=0, yblocks-1 do
				if (OwnerGrid[i][j] ~= "nobody") then counter = counter+1 end
			end
		end
		return counter
	end
	
	
		-- random color-mixing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			CPweight=0.006 --dial this up or down to change the strength of the mixing
			ColorPalette={}; ColorPalette[0]=0; ColorPalette[1]=0; ColorPalette[2]=0
			ColorPaletteNum=0 --these two variables are for weighted averaging of the colors surrounding a space
			if (i>0) then if (OwnerGrid[i][j]~="nobody" and OwnerGrid[i-1][j]~="nobody") then ColorPaletteNum=ColorPaletteNum+1; for k=0, 2 do ColorPalette[k]=ColorPalette[k]+ColorGrid[i-1][j][k] end end end
			if (i<xblocks-1) then if (OwnerGrid[i][j]~="nobody" and OwnerGrid[i+1][j]~="nobody") then ColorPaletteNum=ColorPaletteNum+1; for k=0, 2 do ColorPalette[k]=ColorPalette[k]+ColorGrid[i+1][j][k] end end end
			if (j>0) then if (OwnerGrid[i][j]~="nobody" and OwnerGrid[i][j-1]~="nobody") then ColorPaletteNum=ColorPaletteNum+1; for k=0, 2 do ColorPalette[k]=ColorPalette[k]+ColorGrid[i][j-1][k] end end end
			if (j<yblocks-1) then if (OwnerGrid[i][j]~="nobody" and OwnerGrid[i][j+1]~="nobody") then ColorPaletteNum=ColorPaletteNum+1; for k=0, 2 do ColorPalette[k]=ColorPalette[k]+ColorGrid[i][j+1][k] end end end
			for k=0,2 do
				ColorGrid[i][j][k]=(ColorGrid[i][j][k]+CPweight*ColorPalette[k])/(CPweight*ColorPaletteNum+1)
			end
		end
	end

end
