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
	titleImage = love.graphics.newImage("title.png")
	authorImage = love.graphics.newImage("author.png")
	return self
end

function Title.showit(self)
	if (self.visible==true) then
		love.graphics.draw(titleImage, 192, 128)
		love.graphics.draw(authorImage, 368, 280)
	end
end 
