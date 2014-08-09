function love.load()

require("player_obj")
require("game_obj")
require("title_obj")
require("misc_functions")

--Load sounds
turfsound = love.audio.newSource("turfsound.wav", "static")
stealsound = love.audio.newSource("stealsound.wav", "static")
enemysound = love.audio.newSource("enemysound.wav", "static")
deathsound = love.audio.newSource("deathsound.wav", "static")
rebellionsound = love.audio.newSource("rebellionsound.wav", "static")
	
--Load greyscale images
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

--Load color images
grasslandImageColor = love.graphics.newImage("grassland_tile_color.png")
forestImageColor = love.graphics.newImage("forest_tile_color.png")
desertImageColor = love.graphics.newImage("desert_tile_color.png")
mountainImageColor = love.graphics.newImage("mountain_tile_color.png")
radioactiveImageColor = love.graphics.newImage("radioactive_tile_color.png")
tundraImageColor = love.graphics.newImage("tundra_tile_color.png")
metalImageColor = love.graphics.newImage("metal_tile_color.png")


--flags
flag_green = love.graphics.newImage("flag_green.png")
flag_yellow = love.graphics.newImage("flag_yellow.png")
flag_red = love.graphics.newImage("flag_red.png")

	
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
	
end


function love.draw()

	
	if (maintitle.visible==true) then
		maintitle.DrawEvent(maintitle)
	end
	
	if (maintitle.visible==false) then
		maingame.DrawEvent()
	end
 
end
 

 



