--THIS IS THE LUA FILE THAT HOLDS ALL STUFF RELATED TO THE PLAYER OBJECT -dylan
--The Player object is either the human player or an NPC.  It can grab or own territory, etc.
	
	--Initiate the list that will hold all players for indexing
	PlayerList = {}
	-- for indexing total number of players
	PlayerNumber = -1
	
	--Create the Player object class
	Player = {}
	Player.__index = Player

	function Player.new(givename, givex, givey, r, g, b)
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
		-- variable that is used to handle timing of player land grabs
		self.grabtime=0
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
    function Player.explore (self,steal)
		self.steal = steal --boolean variable that represents whether stealing territory is okay for this move
		local Possibilities = {} --for storing possible pieces of new territory
    	for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				if (self.isAdjacent(self,i,j)==true and OwnerGrid[i][j] == "nobody" and self.steal==false) then 
					table.insert(Possibilities, {i,j})
				end
				if (self.isAdjacent(self,i,j)==true and OwnerGrid[i][j] ~= "nobody" and self.steal==true and OwnerGrid[i][j] ~= self.name) then 
					table.insert(Possibilities, {i,j})
				end
			end
		end
		if (table.getn(Possibilities)>0) then local Choice = Possibilities[love.math.random(1,table.getn(Possibilities))]
		self.acquire (self, Choice[1], Choice[2]) end 
    end
