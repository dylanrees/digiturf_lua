function love.conf(t)

-- to change the number of blocks the screen spans, change the variables directly below
xblocks = 50
yblocks = 40

t.window.width = xblocks*16
t.window.height = yblocks*16+32
    
--Time delay between placing blocks
grab_delay = 15;
--Time delay between stealing blocks
steal_delay = 60;
    
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
--Possible options: "nothing", "water", "chaos", "lava", "radioactive", "forest" (chaos blocks)
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
    
end


		
