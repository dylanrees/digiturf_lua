


function love.load()

	--Time delay between placing blocks
	grab_delay = 15;
	--Time delay between stealing blocks
	steal_delay = 60;

	--TIMEKEEPING
	--number of cycles elapsed in game
	gametime=0
	--time since human player grabbed sometime
	grabtime=0

	--Initialize ColorGrid
	--ColorGrid contains the color in each play cell.  1st and 2nd indices are for position.  
	--3rd is for red, green or blue (indices 0,1,2, respectively)
	ColorGrid = {}
	for i = 0, xblocks-1 do
		ColorGrid[i] = {}
		for j = 0, yblocks-1 do
			ColorGrid[i][j] = {} 
			for k = 0, 2 do
				ColorGrid[i][j][k] = 100
			end
		end
	end

	--Initialize OwnerGrid
	--OwnerGrid tells you what player owns each square 
	OwnerGrid = {}
	for i = 0, xblocks-1 do
		OwnerGrid[i] = {}
		for j = 0, yblocks-1 do
			OwnerGrid[i][j] = "nobody"
		end
	end
	
	--Initialize HazardGrid
	--HazardGrid tells you where non-turf objects are located
	HazardGrid = {}
	for i = 0, xblocks-1 do
		HazardGrid[i] = {}
		for j = 0, yblocks-1 do
			HazardGrid[i][j] = "nothing"
		end
	end
 
 	--Initialize CleaveGrid
	--HazardGrid keeps track of which spaces are about to cleave in two
	CleaveGrid = {}
	for i = 0, xblocks-1 do
		CleaveGrid[i] = {}
		for j = 0, yblocks-1 do
			CleaveGrid[i][j] = 0
		end
	end
	
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
    function Player.explore (self)
		local Possibilities = {} --for storing possible pieces of new territory
    	for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				if (self.isAdjacent(self,i,j)==true and OwnerGrid[i][j] == "nobody") then 
					table.insert(Possibilities, {i,j})
				end
			end
		end
		if (table.getn(Possibilities)>0) then local Choice = Possibilities[love.math.random(1,table.getn(Possibilities))]
		self.acquire (self, Choice[1], Choice[2]) end
    
    end
		
	--Instantiate the first player
	mainplayer = Player.new("mainplayer", 4, 4, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))
	mainplayer.control="human"
	
	cpu1 = Player.new("cpu1", 20, 21, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))
	
	tony = Player.new("tony", 30, 8, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255))

 
	--Load sounds
	 turfsound = love.audio.newSource("turfsound.wav", "static")
 
end

 

function love.update(dt)

	--timekeeping
	gametime=gametime+1
	if grabtime<grab_delay then grabtime=grabtime+1 end
	-- helps with mouse referencing; gives block indices for mouse
	mouse_x = math.floor(love.mouse.getX()/16)
	mouse_y = math.floor(love.mouse.getY()/16)
 
	--UPKEEP LOOP THAT APPLIES TO ALL PLAYERS
	for i = 0, PlayerNumber do
		if (PlayerList[i].grabtime<grab_delay) then PlayerList[i].grabtime=PlayerList[i].grabtime+1 end
		--PlayerList[i].explore(PlayerList[i])
	
		if (PlayerList[i]~=mainplayer and PlayerList[i].grabtime==grab_delay and love.math.random(0,8)==1) then
			PlayerList[i].explore(PlayerList[i])
		end
	
	end
 
	--routine for main player grabbing new tiles
	if (love.mouse.isDown("l")==true and 
		mainplayer.grabtime==grab_delay and 
		mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and 
		OwnerGrid[mouse_x][mouse_y]=="nobody") then 
			mainplayer.acquire(mainplayer,mouse_x,mouse_y)
			mainplayer.grabtime=0
			love.audio.play(turfsound)
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
 
	-- random color-mixing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			CPweight=0.05 --dial this up or down to change the strength of the mixing
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



function love.draw()

	--shade in all the colors from ColorGrid
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 255 )
			-- make human player's boxes flash
			if (math.ceil(gametime/40)-math.floor((gametime-10)/40)==2 and OwnerGrid[i][j]=="mainplayer") then 
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
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==yblocks-1 or (i<yblocks-1 and OwnerGrid[i][j+1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16+16,i*16+16,j*16+16) end
			end
		end
	end
 
	--DIAGNOSTIC TOOL! Displays owner over the block
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (math.floor(love.mouse.getX()/16)==i and math.floor(love.mouse.getY()/16)==j and love.mouse.isDown("l")==true ) then 
				love.graphics.setColor(255, 255, 255, 128)
				love.graphics.print(OwnerGrid[i][j],i*16-8,j*16-16)
			end

		end
	end

 
end
 

 



