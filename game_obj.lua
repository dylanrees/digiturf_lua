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
	-- Note: This mainplayer construct will throw a weird error if it's called wrong
	mainplayer = Player.new(mainplayer, "mainplayer", 15, 15, 0, 128, 200)
	mainplayer.control="human"
	self.CreateAnonPlayer(math.floor(love.math.random(xblocks-1)),math.floor(love.math.random(yblocks-1)), math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)))
	self.CreateAnonPlayer(math.floor(love.math.random(xblocks-1)),math.floor(love.math.random(yblocks-1)), math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)))
		
	--Instantiate some water and chaos
	for i=0, xblocks-1 do
		for j=0, yblocks-1 do
			HazardGrid[i][j] = "metal"
		end
	end
	for i = 0, xblocks-1 do
		HazardGrid[i][yblocks-2] = "water"
		HazardGrid[i][yblocks-1] = "water"
	end	
	for j = 0, yblocks-1 do
		HazardGrid[xblocks-1][j] = "chaos"
	end
	for j = 0, yblocks-1 do
		HazardGrid[0][j] = "lava"
	end
	for i = 0, xblocks-1 do
		HazardGrid[i][1] = "radioactive"
	end
	for i=20, 30 do
		for j=20,30 do
			HazardGrid[i][j] = "forest"
		end
	end
	for i=12, 18 do
		for j=12,18 do
			HazardGrid[i][j] = "mountain"
		end
	end
	for i=4, 10 do
		for j=20,25 do
			HazardGrid[i][j] = "desert"
		end
	end
	for i=34, 40 do
		for j=20,25 do
			HazardGrid[i][j] = "light"
		end
	end
		
		HazardGrid[5][15] = "cave"
		HazardGrid[6][15] = "cave"
		HazardGrid[7][15] = "cave"
		HazardGrid[8][15] = "cave"
		
		for i = 0, xblocks-1 do
		HazardGrid[i][3] = "tundra"
	end
		
	return self
end
	
function Game.DrawEvent()	

	--event for drawing the HUD underneath
	love.graphics.setColor( 0, 0, 0, 255 )
	love.graphics.rectangle("fill", 0, yblocks*16, xblocks*16, 32 )
	love.graphics.setColor( 128, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128, 16 )
	love.graphics.print("Action Points",162,yblocks*16+10)
	love.graphics.setColor( 215, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128*mainplayer.actionpoints/mainplayer.maxactionpoints, 16 )
	
	--HAZARD-DRAWING!
	for i = 0, xblocks-1 do
		for j=0, yblocks-1 do
			love.graphics.setColor(255,255,255, 255 )
			if (HazardGrid[i][j] == "water") then love.graphics.draw(waterImage, i*16, j*16) end
			if (HazardGrid[i][j] == "chaos") then love.graphics.draw(chaosImage, i*16, j*16) end
			if (HazardGrid[i][j] == "lava") then love.graphics.draw(lavaImage, i*16, j*16) end
			if (HazardGrid[i][j] == "radioactive") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(radioactiveImageColor, i*16, j*16) else love.graphics.draw(radioactiveImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "forest") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(forestImageColor, i*16, j*16) else love.graphics.draw(forestImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "mountain") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(mountainImageColor, i*16, j*16) else love.graphics.draw(mountainImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "grassland") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(grasslandImageColor, i*16, j*16) else love.graphics.draw(grasslandImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "desert") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(desertImageColor, i*16, j*16) else love.graphics.draw(desertImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "light") then love.graphics.draw(lightImage, i*16, j*16) end
			if (HazardGrid[i][j] == "cave") then love.graphics.draw(caveImage, i*16, j*16) end
			if (HazardGrid[i][j] == "tundra") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(tundraImageColor, i*16, j*16) else love.graphics.draw(tundraImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "metal") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(metalImageColor, i*16, j*16) else love.graphics.draw(metalImage, i*16, j*16) end end
		end
	end

	--shade in all the colors from ColorGrid
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 128 )
			-- make human player's boxes flash
			if (math.ceil(maingame.gametime/40)-math.floor((maingame.gametime-10)/40)==2 and OwnerGrid[i][j]=="mainplayer") then 
				love.graphics.setColor( (ColorGrid[i][j][0]+3*255)/4, (ColorGrid[i][j][1]+3*255)/4, (ColorGrid[i][j][2]+3*255)/4, 255 )
			end
			-- draw box colors
			if (OwnerGrid[i][j] ~= "nobody") then love.graphics.rectangle("fill", i*16, j*16, 16, 16 ) end
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
				--love.graphics.print("(" .. mainplayer.GetRebelLocus(mainplayer)[1] .. "," .. mainplayer.GetRebelLocus(mainplayer)[2] .. ")",i*16,j*16-8)
				--love.graphics.print(mainplayer.GetRebelRanking(mainplayer),i*16,j*16)
			end	
		end
	end

	--Draw flags for the "rebel territories"
	for k = 0, PlayerNumber do
		if (PlayerList[k].alive==1) then --only do for each player if they're activated
			RebelGrid = PlayerList[k].RebellionSort(PlayerList[k])
			for i = 0, xblocks-1 do
				for j=0, yblocks-1 do
					--love.graphics.setColor( math.max(255-RebelGrid[i][j]*1,0), math.max(255-RebelGrid[i][j]*1,0), math.max(255-RebelGrid[i][j]*1,0), 255 )
					love.graphics.setColor(255,255,255,255)
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 10) then love.graphics.draw(flag_green, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 20) then love.graphics.draw(flag_yellow, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 30) then love.graphics.draw(flag_red, i*16, j*16) end
				end
			end
		end
	end


end

function Game.UpdateEvent()

	maingame.HazardUpdate()

	--timekeeping
	maingame.gametime=maingame.gametime+1
	-- helps with mouse referencing; gives block indices for mouse
	mouse_x = math.floor(love.mouse.getX()/16)
	mouse_y = math.floor(love.mouse.getY()/16)
	
		--UPKEEP LOOP THAT APPLIES TO ALL PLAYERS
	for i = 0, PlayerNumber do
		if (PlayerList[i].alive ==1) then --only perform these actions if the player is activated.
			if (PlayerList[i].actionpoints<PlayerList[i].maxactionpoints) then PlayerList[i].actionpoints=PlayerList[i].actionpoints+0.5+PlayerList[i].GetLandExtent(PlayerList[i])/200 end
		
			if (PlayerList[i]~=mainplayer) then -- this routine is for NPCs
				ExploreResults = PlayerList[i].explore(PlayerList[i])
				if (ExploreResults[0] ~= 999) then
					if (PlayerList[i].actionpoints>=ExploreResults[0]) then 
						PlayerList[i].actionpoints=PlayerList[i].actionpoints-ExploreResults[0]
						PlayerList[i].acquire(PlayerList[i], ExploreResults[1], ExploreResults[2])
					end	
				end
			else								-- this routine is for the human player
				if (love.mouse.isDown("l")==true) then 
					if (mainplayer.actionpoints>=GetGrabCost(mouse_x,mouse_y) and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]=="nobody" and IsSolid(mouse_x,mouse_y)==false) then
						mainplayer.acquire(mainplayer,mouse_x,mouse_y)
						mainplayer.actionpoints=mainplayer.actionpoints-GetGrabCost(mouse_x,mouse_y)
						love.audio.play(turfsound)
					end
					if (mainplayer.actionpoints>=GetStealCost(mouse_x,mouse_y) and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]~="nobody" and OwnerGrid[mouse_x][mouse_y]~="mainplayer" and IsSolid(mouse_x,mouse_y)==false) then
						mainplayer.acquire(mainplayer,mouse_x,mouse_y)
						mainplayer.actionpoints=mainplayer.actionpoints-GetStealCost(mouse_x,mouse_y)
						love.audio.play(stealsound)
					end
				end
			end
		end
	end
	
		-- random cell color-changing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (OwnerGrid[i][j]~="nobody") then
				ColorGrid[i][j][0] = ColorGrid[i][j][0] + GetStability(i,j)*love.math.random(-1,1)
				ColorGrid[i][j][1] = ColorGrid[i][j][1] + GetStability(i,j)*love.math.random(-1,1)
				ColorGrid[i][j][2] = ColorGrid[i][j][2] + GetStability(i,j)*love.math.random(-1,1)
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
	
	
		 --random color-mixing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			CPweight=0.003 --dial this up or down to change the strength of the mixing
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
	


	-- light tile effect
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			lightening = 0
			if (i>0) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i-1][j]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (i<xblocks-1) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i+1][j]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (j>0) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i][j-1]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (j<yblocks-1) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i][j+1]=="light") then lightening = lightening + love.math.random(5)/20 end end
			ColorGrid[i][j][0] = ColorGrid[i][j][0] + lightening
			ColorGrid[i][j][1] = ColorGrid[i][j][1] + lightening
			ColorGrid[i][j][2] = ColorGrid[i][j][2] + lightening
		end
	end


	--cave effect
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (i>0) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i-1][j]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (i<xblocks-1) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i+1][j]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (j>0) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i][j-1]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (j<yblocks-1) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i][j+1]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
		end
	end


	maingame.PlayerCleanup(maingame)

end

function Game.HazardUpdate()

	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- chaos block effect that changes tile colors a lot
			if (OwnerGrid[i][j]~="nobody" and ((i<xblocks-1 and HazardGrid[i+1][j] == "chaos") or (i>0 and HazardGrid[i-1][j] == "chaos") or (j>0 and HazardGrid[i][j-1] == "chaos") or (j<yblocks-1 and HazardGrid[i][j+1] == "chaos"))) then
				ColorGrid[i][j][0] = ColorGrid[i][j][0] + love.math.random(-8,8)
				ColorGrid[i][j][1] = ColorGrid[i][j][1] + love.math.random(-8,8)
				ColorGrid[i][j][2] = ColorGrid[i][j][2] + love.math.random(-8,8)
				ColorGrid[i][j][0] = math.min(math.abs(ColorGrid[i][j][0]),255)
				ColorGrid[i][j][1] = math.min(math.abs(ColorGrid[i][j][1]),255)
				ColorGrid[i][j][2] = math.min(math.abs(ColorGrid[i][j][2]),255)			
			end
			-- depopulation effect (like lava)
			local DeathDieRoll = love.math.random(1,400000)
			if (OwnerGrid[i][j]~="nobody" and ((i<xblocks-1 and GetDepop(i+1,j) > 0)) and DeathDieRoll<=GetDepop(i+1,j)) then
				depop(i,j)
			end
			if (OwnerGrid[i][j]~="nobody" and ((i>0 and GetDepop(i-1,j) > 0)) and DeathDieRoll<=GetDepop(i-1,j)) then
				depop(i,j)
			end
			if (OwnerGrid[i][j]~="nobody" and ((j>0 and GetDepop(i,j-1) > 0)) and DeathDieRoll<=GetDepop(i,j-1)) then
				depop(i,j)
			end
			if (OwnerGrid[i][j]~="nobody" and ((j<yblocks-1 and GetDepop(i,j+1) > 0)) and DeathDieRoll<=GetDepop(i,j+1)) then
				depop(i,j)
			end
			if (OwnerGrid[i][j]~="nobody" and ((GetDepop(i,j) > 0)) and DeathDieRoll<=GetDepop(i,j)) then
				depop(i,j)
			end
		end
	end
end

--creates a new NPC player at given position and gives it an automatic name
function Game.CreateAnonPlayer(xpos,ypos,red,green,blue) 
local name = "player" .. table.getn(PlayerList)
local makeplayer = Player.new(makeplayer, name, xpos, ypos, red, green, blue)
return makeplayer
end

function Game.PlayerCleanup(self)  --checks for all players with no more territory and "deactivates" them
local action = false --flips to true if the routine actually has to eliminate any players
		for i = 0, PlayerNumber do
			if (PlayerList[i].GetLandExtent(PlayerList[i])==0 and PlayerList[i].alive==1 ) then
				PlayerList[i].alive=0
				action = true
			end
		end
	if (action == true) then love.audio.play(deathsound) end
end
