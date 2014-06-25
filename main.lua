function love.load()

require("player_obj")
require("game_obj")
require("title_obj")
require("misc_functions")
	
maintitle = Title.new()
		
end

 
function love.update(dt)

	if (love.keyboard.isDown(" ")==true and maintitle.visible==true) then
		maintitle.visible=false
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				for k = 0, 2 do
					ColorGrid[i][j][k] = 100
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
 

 



