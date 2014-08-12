--THIS IS THE LUA FILE THAT HOLDS ALL STUFF RELATED TO THE GAME OBJECT -dylan
--A game object sets up and maintains an actual game.  It handles things 
--like players and some timekeeping.

--Create the Game object class
Game = {}
Game.__index = Game

--DrawEvent and UpdateEvent are in their own files
require("game_drawevent")
require("game_updateevent")
	
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
		for j=0, 30 do
			HazardGrid[i][j] = "grassland"
		end
	end
	
	for i=0, xblocks-1 do
		for j=30, yblocks-1 do
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
	

	for j=12,18 do
			HazardGrid[11][j] = "tallmountain"
	end

	for i=12,18 do
			HazardGrid[i][11] = "stronghold"
	end
	
	
	for i=4, 10 do
		for j=20,25 do
			HazardGrid[i][j] = "desert"
		end
	end
	
	for i=34, 40 do
		for j=20,24 do
			HazardGrid[i][j] = "light"
		end
	end
	
	for i=34, 40 do
		for j=25,30 do
			HazardGrid[i][j] = "dark"
		end
	end
		
		HazardGrid[5][15] = "cave"
		HazardGrid[6][15] = "cave"
		HazardGrid[7][15] = "cave"
		HazardGrid[8][15] = "cave"
		
		HazardGrid[25][20] = "stonehead"
		HazardGrid[26][20] = "stonehead"
		HazardGrid[27][20] = "stonehead"
		HazardGrid[28][20] = "stonehead"
		
		for i = 0, xblocks-1 do
		HazardGrid[i][3] = "tundra"
	end
		
	return self
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

function Game.PlayerCleanup(self)  
local action = false --flips to true if the routine has to eliminate any players
		for i = 0, PlayerNumber do
			if (PlayerList[i].GetLandExtent(PlayerList[i])==0 and PlayerList[i].alive==1 ) then
				PlayerList[i].alive=0  --checks for all players with no more territory and "deactivates" them
				action = true
			end
			if (PlayerList[i].GetLandExtent(PlayerList[i])>=1 and OwnerGrid[PlayerList[i].originx][PlayerList[i].originy]~=PlayerList[i].name) then
				PlayerList[i].PickNewTown(PlayerList[i])
			end
		end
	if (action == true) then love.audio.play(deathsound) end
end
