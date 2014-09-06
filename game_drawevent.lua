function Game.DrawEvent()	

	--HUD-drawing routing
	love.graphics.setColor( 0, 0, 0, 255 )
	love.graphics.rectangle("fill", 0, yblocks*16, xblocks*16, 128 )
	love.graphics.setColor( 128, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128, 16 )
	love.graphics.print("Action Points",162,yblocks*16+10)
	love.graphics.setColor( 215, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128*mainplayer.actionpoints/mainplayer.maxactionpoints, 16 )
	
	--DRAW LOOP FOR ALL BLOCKS
	for i = 0, xblocks-1 do
		for j=0, yblocks-1 do
		
			-- Hazard tile-drawing routine
			love.graphics.setColor(255,255,255, 255 )
			for k=1, table.getn(tilenames) do
				if (HazardGrid[i][j] == hazardAttr[k][0]) then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(hazardImage, hazardAttr[k][1], i*16, j*16) else love.graphics.draw(hazardImage, hazardAttr[k][2], i*16, j*16) end end
			end
		
			-- ColorGrid shading routine
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 128 )
			-- make human player's boxes flash
			if (math.ceil(maingame.gametime/40)-math.floor((maingame.gametime-10)/40)==2 and OwnerGrid[i][j]=="mainplayer") then 
				love.graphics.setColor( (ColorGrid[i][j][0]+3*255)/4, (ColorGrid[i][j][1]+3*255)/4, (ColorGrid[i][j][2]+3*255)/4, 255 )
			end
			-- draw box colors
			if (OwnerGrid[i][j] ~= "nobody") then love.graphics.rectangle("fill", i*16, j*16, 16, 16 ) end
		
			--DRAW LOOP FOR ALL PLAYERS
			for k = 1, PlayerNumber do
				
				-- draw the borders for every player
				love.graphics.setColor(0,0,0, 255 )
				love.graphics.setLineWidth(1)
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==0 or (i>0 and OwnerGrid[i-1][j]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==xblocks-1 or (i<xblocks-1 and OwnerGrid[i+1][j]~=PlayerList[k].name))) then love.graphics.line(i*16+16,j*16,i*16+16,j*16+16) ; love.graphics.line(i*16+16-1,j*16,i*16+16-1,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==0 or (j>0 and OwnerGrid[i][j-1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16+16,j*16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==yblocks-1 or (j<yblocks-1 and OwnerGrid[i][j+1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16+16,i*16+16,j*16+16) ; love.graphics.line(i*16,j*16+16-1,i*16+16,j*16+16-1) end		
			
				--draw player big cities
				love.graphics.setColor(PlayerList[k].cityr,PlayerList[k].cityg,PlayerList[k].cityb,255)
				if (OwnerGrid[i][j]==PlayerList[k].name and PlayerList[k].originx==i and PlayerList[k].originy==j) then love.graphics.draw(cityImage, PlayerList[k].cityquad, i*16, j*16) end
				--draw player little cities
				if (OwnerGrid[i][j]==PlayerList[k].name and PlayerList[k].originx==i and PlayerList[k].originy==j) then love.graphics.draw(littlecityImage, PlayerList[k].littlecityquad, i*16, j*16) end

				--Draw flags for the "rebel territories"
				if (PlayerList[k].alive==1) then --only do for each player if they're activated
					love.graphics.setColor(255,255,255,255)
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 10) then love.graphics.draw(flagImage, flag_green, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 20) then love.graphics.draw(flagImage, flag_yellow, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 30) then love.graphics.draw(flagImage, flag_red, i*16, j*16) end
				end

			end		
		end
	end
	
	--DIAGNOSTIC TOOL! Displays territory owner over the block with mouse press
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			if (math.floor(love.mouse.getX()/16)==i and math.floor(love.mouse.getY()/16)==j ) then 
				love.graphics.setColor(255, 255, 255, 128)
				--love.graphics.print("(" .. mainplayer.GetRebelLocus(mainplayer)[1] .. "," .. mainplayer.GetRebelLocus(mainplayer)[2] .. ")",i*16,j*16-8)
				--love.graphics.print(mainplayer.GetRebelRanking(mainplayer),i*16,j*16)
			end	
		end
	end

	-- Draw leaderboard
	skipped = 0 --used to properly skip through dead players in the leaderboard
	for i=1, math.min(4+skipped,PlayerNumber) do
		if (PlayerList[i].alive==1) then
			love.graphics.setColor(PlayerList[i].cityr,PlayerList[i].cityg,PlayerList[i].cityb,255)
			love.graphics.draw(cityImage, PlayerList[i].cityquad, 300, 632+16*(i-skipped))
			love.graphics.draw(littlecityImage, PlayerList[i].littlecityquad, 300, 632+16*(i-skipped))
			love.graphics.setColor(PlayerList[i].red, PlayerList[i].green, PlayerList[i].blue, 255)
			love.graphics.rectangle("fill", 316, 632+16*(i-skipped), PlayerList[i].GetLandExtent(PlayerList[i]), 16 )
			love.graphics.print(tostring(PlayerList[i].avgx),450,632+16*(i-skipped))
			love.graphics.print(tostring(PlayerList[i].avgy),500,632+16*(i-skipped))
		else 
			skipped = skipped+1
		end
	end

end
