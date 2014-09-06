--THIS IS THE LUA FILE THAT HOLDS ALL STUFF RELATED TO THE TITLE OBJECT -dylan
-- The title object basically pops up when the game starts and allows you
-- to flip through menus or start a game (instantiating a game object).

--Create the Title object class
Title = {}
Title.__index = Title
	
function Title.new()
	local self = setmetatable({}, Title)
	self.visible=true
	-- this is pretty much a placeholder
	titleImage = love.graphics.newImage("resources/title.png")
	authorImage = love.graphics.newImage("resources/author.png")
	love.graphics.setBackgroundColor(128, 128, 128)
	self.red1 = 0
	self.green1 = 0
	self.blue1 = 255
	self.red2 = 0
	self.green2 = 255
	self.blue2 = 0
	return self
end

function Title.DrawEvent(self)
	if (self.visible==true) then

	--shade in all the colors from ColorGrid
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 255 )
			-- draw box colors
			love.graphics.rectangle("fill", i*16, j*16, 16, 16 )
		end
	end
	

	love.graphics.draw(titleImage, 192, 128)
	love.graphics.draw(authorImage, 368, 280)
		
	end
end 

function Title.UpdateEvent(self)

		-- random cell color-changing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
				ColorGrid[i][j][0] = ColorGrid[i][j][0] + love.math.random(-1,1)
				ColorGrid[i][j][1] = ColorGrid[i][j][1] + love.math.random(-1,1)
				ColorGrid[i][j][2] = ColorGrid[i][j][2] + love.math.random(-1,1)
				ColorGrid[i][j][0] = math.min(math.abs(ColorGrid[i][j][0]),255)
				ColorGrid[i][j][1] = math.min(math.abs(ColorGrid[i][j][1]),255)
				ColorGrid[i][j][2] = math.min(math.abs(ColorGrid[i][j][2]),255)			
		end
	end
	
end 
