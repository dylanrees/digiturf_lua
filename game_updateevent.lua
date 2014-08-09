
function Game.UpdateEvent()

	maingame.HazardUpdate()

	--timekeeping
	maingame.gametime=maingame.gametime+1
	-- helps with mouse referencing; gives block indices for mouse
	mouse_x = math.floor(love.mouse.getX()/16)
	mouse_y = math.floor(love.mouse.getY()/16)
	
		--UPKEEP LOOP THAT APPLIES TO ALL PLAYERS
	for i = 0, PlayerNumber do
		if (PlayerList[i].alive ==1) then --only perform these actions if the player is activated.
			if (PlayerList[i].actionpoints<PlayerList[i].maxactionpoints) then PlayerList[i].actionpoints=PlayerList[i].actionpoints+0.5+PlayerList[i].GetLandExtent(PlayerList[i])/200 end
		
			if (PlayerList[i]~=mainplayer) then -- this routine is for NPCs
				ExploreResults = PlayerList[i].explore(PlayerList[i])
				if (ExploreResults[0] ~= 999) then
					if (PlayerList[i].actionpoints>=ExploreResults[0]) then 
						PlayerList[i].actionpoints=PlayerList[i].actionpoints-ExploreResults[0]
						PlayerList[i].acquire(PlayerList[i], ExploreResults[1], ExploreResults[2])
					end	
				end
			else								-- this routine is for the human player
				if (love.mouse.isDown("l")==true) then 
					if (mainplayer.actionpoints>=GetGrabCost(mouse_x,mouse_y) and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]=="nobody" and IsSolid(mouse_x,mouse_y)==false) then
						mainplayer.acquire(mainplayer,mouse_x,mouse_y)
						mainplayer.actionpoints=mainplayer.actionpoints-GetGrabCost(mouse_x,mouse_y)
						love.audio.play(turfsound)
					end
					if (mainplayer.actionpoints>=GetStealCost(mouse_x,mouse_y) and mainplayer.isAdjacent(mainplayer,mouse_x,mouse_y)==true and OwnerGrid[mouse_x][mouse_y]~="nobody" and OwnerGrid[mouse_x][mouse_y]~="mainplayer" and IsSolid(mouse_x,mouse_y)==false) then
						mainplayer.acquire(mainplayer,mouse_x,mouse_y)
						mainplayer.actionpoints=mainplayer.actionpoints-GetStealCost(mouse_x,mouse_y)
						love.audio.play(stealsound)
					end
				end
			end
		end
	end
	
			if (love.mouse.isDown("r")==true) then 
				maingame.CreateAnonPlayer(mouse_x,mouse_y, math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)), math.floor(love.math.random(0,255)))
			end
	
		-- random cell color-changing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (OwnerGrid[i][j]~="nobody") then
				ColorGrid[i][j][0] = ColorGrid[i][j][0] + GetStability(i,j)*love.math.random(-1,1)
				ColorGrid[i][j][1] = ColorGrid[i][j][1] + GetStability(i,j)*love.math.random(-1,1)
				ColorGrid[i][j][2] = ColorGrid[i][j][2] + GetStability(i,j)*love.math.random(-1,1)
				ColorGrid[i][j][0] = math.min(math.abs(ColorGrid[i][j][0]),255)
				ColorGrid[i][j][1] = math.min(math.abs(ColorGrid[i][j][1]),255)
				ColorGrid[i][j][2] = math.min(math.abs(ColorGrid[i][j][2]),255)			
			end
		end
	end
	
	function Game.GetLandTotal (self) --function to determine how much land is controlled by players in total
		local counter=0
		for i=0, xblocks-1 do
			for j=0, yblocks-1 do
				if (OwnerGrid[i][j] ~= "nobody") then counter = counter+1 end
			end
		end
		return counter
	end
	
	
		 --random color-mixing routine
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			CPweight=0.003 --dial this up or down to change the strength of the mixing
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
	


	-- light tile effect
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			lightening = 0
			if (i>0) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i-1][j]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (i<xblocks-1) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i+1][j]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (j>0) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i][j-1]=="light") then lightening = lightening + love.math.random(5)/20 end end
			if (j<yblocks-1) then if (OwnerGrid[i][j]~="nobody" and HazardGrid[i][j+1]=="light") then lightening = lightening + love.math.random(5)/20 end end
			ColorGrid[i][j][0] = ColorGrid[i][j][0] + lightening
			ColorGrid[i][j][1] = ColorGrid[i][j][1] + lightening
			ColorGrid[i][j][2] = ColorGrid[i][j][2] + lightening
		end
	end


	--cave effect
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (i>0) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i-1][j]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (i<xblocks-1) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i+1][j]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (j>0) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i][j-1]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
			if (j<yblocks-1) then if (IsSolid(i,j) == false and OwnerGrid[i][j]=="nobody" and HazardGrid[i][j+1]=="cave" and love.math.random(1,10000)==1) then player = maingame.CreateAnonPlayer(i,j, love.math.random(0,255), love.math.random(0,255), love.math.random(0,255)) end end
		end
	end


	maingame.PlayerCleanup(maingame)

end
