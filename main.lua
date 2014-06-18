function love.load()

require("player_obj")
require("game_obj")
require("title_obj")
	
--maintitle = Title.new()
maingame = Game.new()
		
end

 
function love.update(dt)

maingame.UpdateEvent()

end


function love.draw()

	maingame.DrawEvent()

	--draw the title... when appropriate
	--maintitle.showit(maintitle)
 
end
 

 



