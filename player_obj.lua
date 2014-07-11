--THIS IS THE LUA FILE THAT HOLDS ALL STUFF RELATED TO THE PLAYER OBJECT -dylan
--The Player object is either the human player or an NPC.  It can grab or own territory, etc.
	
	--Initiate the list that will hold all players for indexing
	PlayerList = {}
	-- for indexing total number of players
	PlayerNumber = -1
	
	--Create the Player object class
	Player = {}
	Player.__index = Player

	function Player.new(self, givename, givex, givey, r, g, b)
		local self = setmetatable({}, Player)
		PlayerNumber = PlayerNumber + 1
		PlayerList[PlayerNumber] = self --update player list with this new player
		self.red=r 
		self.green=g  --signifies the color of NEW blocks that enter player ownership
		self.blue=b 
		self.name=givename
		self.control="cpu"  --cpu = computer A.I. (default), human = controlled by player at keyboard.  Maybe other A.I. types/networking later
		self.cursorx=givex
		self.cursory=givey
		-- effects the creation of a new player produces in the environment
		ColorGrid[givex][givey][0] = r
		ColorGrid[givex][givey][1] = g
		ColorGrid[givex][givey][2] = b
		OwnerGrid[givex][givey]=self.name
		self.actionpoints=0 --these are spent on land grabs and other actions
		self.maxactionpoints=100 --top of the chart
		self.intelligence = 0.5
		self.StealVal = 0.5+love.math.random(1,10)/10 --coefficient for the value of stealing territory
		self.TerritoryVal = 0.5+love.math.random(1,10)/10 --coefficient for the value of any new territory
		self.NiceBorderVal = 0.1+love.math.random(1,10)/10 --coefficient for the value of reducing overall border surface area
		return self
	end
	
	--Method for a player to grab a block of territory
    function Player.acquire (self, xspec, yspec)
		OwnerGrid[xspec][yspec] = self.name
		ColorGrid[xspec][yspec][0] = self.red
        ColorGrid[xspec][yspec][1] = self.green
        ColorGrid[xspec][yspec][2] = self.blue
    end

    --Method for checking whether a given square is adjacent to a given player
    function  Player.isAdjacent (self, xspec, yspec)
		local check=false
		if (xspec>0) then if OwnerGrid[xspec - 1][yspec] == self.name then check=true end end
		if (xspec<xblocks-1) then if OwnerGrid[xspec + 1][yspec] == self.name then check=true end end
		if (yspec>0) then if OwnerGrid[xspec][yspec-1] == self.name then check=true end end
		if (yspec<yblocks-1) then if OwnerGrid[xspec][yspec+1] == self.name then check=true end	end
		return check
    end
    
    --Method for a non-human player to grab some territory
    function Player.explore (self)
		local Results = {}
		Results[0]=999
		Choice = self.choose(self)
		Results[1]=Choice[1]
		Results[2]=Choice[2]
		if (OwnerGrid[Choice[1]][Choice[2]] == "nobody") then 
			Results[0] = GetGrabCost(Choice[1], Choice[2])
		else 
			Results[0] = GetStealCost(Choice[1], Choice[2])
		end
		return Results
		--self.acquire (self, Choice[1], Choice[2])
    end
    
    function Player.GetLandExtent (self) --function to determine how much land the player controls
		local counter=0
		for i=0, xblocks-1 do
			for j=0, yblocks-1 do
				if (OwnerGrid[i][j] == self.name) then counter = counter+1 end
			end
		end
		return counter
	end
	
	function Player.GetMarginalBorder (self, xpos, ypos) --determines how your border length would change if this tile were claimed
		local counter = -1
		if (OwnerGrid[xpos][ypos] ~= self.name and self.isAdjacent(self, xpos, ypos)==true) then
			local initial = 0
			local final = 0
			if (xpos>0 and OwnerGrid[xpos-1][ypos] == self.name) then initial = initial+1 else final = final+1 end
			if (xpos<xblocks-1 and OwnerGrid[xpos+1][ypos] == self.name) then initial = initial+1 else final = final+1 end
			if (ypos>0 and OwnerGrid[xpos][ypos-1] == self.name) then initial = initial+1 else final = final+1 end
			if (ypos<yblocks-1 and OwnerGrid[xpos][ypos+1] == self.name) then initial = initial+1 else final = final+1 end
			counter =  final - initial
		end
		return counter
	end
	
	function Player.MarginalBenefit (self, xpos, ypos) --Analyzes the benefit of claiming a given square for player
		local result = -100
		if (self.isAdjacent (self, xpos, ypos) and OwnerGrid[xpos][ypos] ~= self.name) then
			result = self.TerritoryVal
			if (OwnerGrid[xpos][ypos] ~= "nobody") then result = result+self.StealVal end
			result = result - self.NiceBorderVal*self.GetMarginalBorder(self, xpos, ypos) + 2
		end
		return result
	end
	
    -- Method for using genetic-algorithm inspired A.I. to choose the next move
    function Player.choose (self)
    	local Possibilities1 = {} --for storing possible pieces of new territory
    	for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				if (self.isAdjacent(self,i,j)==true and OwnerGrid[i][j] == "nobody" and IsSolid(i,j) == false) then 
					table.insert(Possibilities1, {i,j})
				end
				if (self.isAdjacent(self,i,j)==true and OwnerGrid[i][j] ~= "nobody" and OwnerGrid[i][j] ~= self.name and IsSolid(i,j) == false) then 
					table.insert(Possibilities1, {i,j})
				end
			end
		end
		local Possibilities2 = {} --for storing possibilities after fitness + intelligence vetting
		local MinOption = 100
		local MinOptionIndex = -1
		local MaxOption = -100
		local MaxOptionIndex = -1
		for i=1, table.getn(Possibilities1) do
			if (self.MarginalBenefit(self, Possibilities1[i][1], Possibilities1[i][2])<MinOption) then 
				MinOptionIndex = i
				MinOption = self.MarginalBenefit(self, Possibilities1[i][1], Possibilities1[i][2])
			end
			if (self.MarginalBenefit(self, Possibilities1[i][1], Possibilities1[i][2])>MaxOption) then 
				MaxOptionIndex = i 
				MaxOption = self.MarginalBenefit(self, Possibilities1[i][1], Possibilities1[i][2])
			end
		end
		local pivot = (MaxOption-MinOption)*self.intelligence+MinOption
		for i=1, table.getn(Possibilities1) do
			if (self.MarginalBenefit(self, Possibilities1[i][1], Possibilities1[i][2])>= pivot) then --pivot
				table.insert(Possibilities2, Possibilities1[i])
			end
		end
		return Possibilities2[love.math.random(1,table.getn(Possibilities2))]
    end
