function love.load()

	require("player_obj")
	require("game_obj")
	require("title_obj")
	require("tile_functions")

	--Load sounds
	turfsound = love.audio.newSource("resources/turfsound.wav", "static")
	stealsound = love.audio.newSource("resources/stealsound.wav", "static")
	enemysound = love.audio.newSource("resources/enemysound.wav", "static")
	deathsound = love.audio.newSource("resources/deathsound.wav", "static")
	rebellionsound = love.audio.newSource("resources/rebellionsound.wav", "static")
	
	--Load hazard image
	hazardImage = love.graphics.newImage("resources/hazards.png")
	--Hazard attribute array will store the quads according to index.
	--Usage: 
		--hazardAttr[i][0] stores the name 
		--hazardAttr[i][1] stores the color quad
		--hazardAttr[i][1] stores b+w quad
	hazardAttr = {}
	hazardAttr[1] = {}
	hazardAttr[1][0] = tilenames[1]
	hazardAttr[1][0] = love.graphics.newQuad(0,0,0,0, hazardImage:getDimensions()) -- the "nothing" hazard gets a dummy quad
	hazardAttr[1][0] = love.graphics.newQuad(0,0,0,0, hazardImage:getDimensions())
	for i = 2, table.getn(tilenames) do
		hazardAttr[i] = {}
		hazardAttr[i][0] = tilenames[i]
		hazardAttr[i][1] = love.graphics.newQuad(((i-2)%8)*16,math.floor((i-2)/8)*16,16,16, hazardImage:getDimensions())
		hazardAttr[i][2] = love.graphics.newQuad(((i-2)%8)*16+128,math.floor((i-2)/8)*16,16,16, hazardImage:getDimensions())
	end

	--Load city graphics
	cityImage = love.graphics.newImage("resources/cities_big.png")
	littlecityImage = love.graphics.newImage("resources/cities_little.png")

	--flag image
	flagImage = love.graphics.newImage("resources/flags.png")
	--flag quads
	flag_green = love.graphics.newQuad(0,0,16,16, flagImage:getDimensions())
	flag_yellow = love.graphics.newQuad(16,0,16,16, flagImage:getDimensions())
	flag_red = love.graphics.newQuad(32,0,16,16, flagImage:getDimensions())

	--figure out which resolutions are supported
	modes = love.window.getFullscreenModes()
	table.sort(modes, function(a, b) return a.width*a.height < b.width*b.height end)   -- sort from smallest to largest
	--love.window.setMode(800,600, {fullscreen=true})

	--create the title	
	maintitle = Title.new()
		
end

function love.update(dt)

	if (love.keyboard.isDown(" ")==true and maintitle.visible==true) then
		maintitle.visible=false
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				for k = 0, 2 do
					ColorGrid[i][j][k] = 50
				end
			end
		end	
	maingame = Game.new(maingame)
	end
	
	if (maintitle.visible==true) then
		maintitle.UpdateEvent(maintitle)
	end

	if (maintitle.visible==false) then
		maingame.UpdateEvent()
	end
	
   --allow exiting the game with the escape key
   if love.keyboard.isDown('escape')==true then
      love.event.quit()
   end
	
end


function love.draw()

	if (maintitle.visible==true) then
		maintitle.DrawEvent(maintitle)
	end
	
	if (maintitle.visible==false) then
		maingame.DrawEvent()
	end
 
end
 

 



