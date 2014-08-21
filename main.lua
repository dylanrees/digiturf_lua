function love.load()

require("player_obj")
require("game_obj")
require("title_obj")
require("tile_functions")

--Load sounds
turfsound = love.audio.newSource("turfsound.wav", "static")
stealsound = love.audio.newSource("stealsound.wav", "static")
enemysound = love.audio.newSource("enemysound.wav", "static")
deathsound = love.audio.newSource("deathsound.wav", "static")
rebellionsound = love.audio.newSource("rebellionsound.wav", "static")
	
--Load greyscale images (and color images for tiles that have only one image)
waterImage = love.graphics.newImage("water_tile.png")
chaosImage = love.graphics.newImage("chaos_tile.png")
lavaImage = love.graphics.newImage("lava_tile.png")
radioactiveImage = love.graphics.newImage("radioactive_tile.png")
forestImage = love.graphics.newImage("forest_tile.png")
mountainImage = love.graphics.newImage("mountain_tile.png")
grasslandImage = love.graphics.newImage("grassland_tile.png")
desertImage = love.graphics.newImage("desert_tile.png")
lightImage = love.graphics.newImage("light_tile.png")
caveImage = love.graphics.newImage("cave_tile.png")
tundraImage = love.graphics.newImage("tundra_tile.png")
metalImage = love.graphics.newImage("metal_tile.png")
darkImage = love.graphics.newImage("dark_tile.png")
stoneheadImage = love.graphics.newImage("stonehead_tile.png")
tallmountainImage = love.graphics.newImage("tallmountain_tile.png")
strongholdImage = love.graphics.newImage("stronghold_tile.png")

--Load color images
grasslandImageColor = love.graphics.newImage("grassland_tile_color.png")
forestImageColor = love.graphics.newImage("forest_tile_color.png")
desertImageColor = love.graphics.newImage("desert_tile_color.png")
mountainImageColor = love.graphics.newImage("mountain_tile_color.png")
radioactiveImageColor = love.graphics.newImage("radioactive_tile_color.png")
tundraImageColor = love.graphics.newImage("tundra_tile_color.png")
metalImageColor = love.graphics.newImage("metal_tile_color.png")
strongholdImageColor = love.graphics.newImage("stronghold_tile_color.png")


--Load city graphics
cityImage = love.graphics.newImage("resources/cities_big.png")


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
 

 



