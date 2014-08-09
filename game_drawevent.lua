function Game.DrawEvent()	

	--event for drawing the HUD underneath
	love.graphics.setColor( 0, 0, 0, 255 )
	love.graphics.rectangle("fill", 0, yblocks*16, xblocks*16, 32 )
	love.graphics.setColor( 128, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128, 16 )
	love.graphics.print("Action Points",162,yblocks*16+10)
	love.graphics.setColor( 215, 128, 128, 255 )
	love.graphics.rectangle("fill", 32, yblocks*16+8, 128*mainplayer.actionpoints/mainplayer.maxactionpoints, 16 )
	
	--HAZARD-DRAWING!
	for i = 0, xblocks-1 do
		for j=0, yblocks-1 do
			love.graphics.setColor(255,255,255, 255 )
			if (HazardGrid[i][j] == "water") then love.graphics.draw(waterImage, i*16, j*16) end
			if (HazardGrid[i][j] == "chaos") then love.graphics.draw(chaosImage, i*16, j*16) end
			if (HazardGrid[i][j] == "lava") then love.graphics.draw(lavaImage, i*16, j*16) end
			if (HazardGrid[i][j] == "radioactive") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(radioactiveImageColor, i*16, j*16) else love.graphics.draw(radioactiveImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "forest") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(forestImageColor, i*16, j*16) else love.graphics.draw(forestImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "mountain") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(mountainImageColor, i*16, j*16) else love.graphics.draw(mountainImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "grassland") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(grasslandImageColor, i*16, j*16) else love.graphics.draw(grasslandImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "desert") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(desertImageColor, i*16, j*16) else love.graphics.draw(desertImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "light") then love.graphics.draw(lightImage, i*16, j*16) end
			if (HazardGrid[i][j] == "cave") then love.graphics.draw(caveImage, i*16, j*16) end
			if (HazardGrid[i][j] == "tundra") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(tundraImageColor, i*16, j*16) else love.graphics.draw(tundraImage, i*16, j*16) end end
			if (HazardGrid[i][j] == "metal") then if (OwnerGrid[i][j] == "nobody") then love.graphics.draw(metalImageColor, i*16, j*16) else love.graphics.draw(metalImage, i*16, j*16) end end
		end
	end

	--shade in all the colors from ColorGrid
	for i = 0, xblocks-1 do
		for j = 0, yblocks-1 do
			-- aquire box colors
			love.graphics.setColor( ColorGrid[i][j][0], ColorGrid[i][j][1], ColorGrid[i][j][2], 128 )
			-- make human player's boxes flash
			if (math.ceil(maingame.gametime/40)-math.floor((maingame.gametime-10)/40)==2 and OwnerGrid[i][j]=="mainplayer") then 
				love.graphics.setColor( (ColorGrid[i][j][0]+3*255)/4, (ColorGrid[i][j][1]+3*255)/4, (ColorGrid[i][j][2]+3*255)/4, 255 )
			end
			-- draw box colors
			if (OwnerGrid[i][j] ~= "nobody") then love.graphics.rectangle("fill", i*16, j*16, 16, 16 ) end
		end
	end
	
	--DRAW LOOP THAT APPLIES TO ALL PLAYERS
	for k = 0, PlayerNumber do
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
			
				-- draw the borders for every player
				love.graphics.setColor(0,0,0, 255 )
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==0 or (i>0 and OwnerGrid[i-1][j]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (i==xblocks-1 or (i<xblocks-1 and OwnerGrid[i+1][j]~=PlayerList[k].name))) then love.graphics.line(i*16+16,j*16,i*16+16,j*16+16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==0 or (j>0 and OwnerGrid[i][j-1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16,i*16+16,j*16) end
				if (OwnerGrid[i][j]==PlayerList[k].name and (j==yblocks-1 or (j<yblocks-1 and OwnerGrid[i][j+1]~=PlayerList[k].name))) then love.graphics.line(i*16,j*16+16,i*16+16,j*16+16) end		
			
				--draw player cities
				love.graphics.setColor(255,255,255, 255 )
				if (OwnerGrid[i][j]==PlayerList[k].name and PlayerList[k].originx==i and PlayerList[k].originy==j) then love.graphics.draw(cityImage, i*16, j*16) end
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

	--Draw flags for the "rebel territories"
	for k = 0, PlayerNumber do
		if (PlayerList[k].alive==1) then --only do for each player if they're activated
			RebelGrid = PlayerList[k].RebellionSort(PlayerList[k])
			for i = 0, xblocks-1 do
				for j=0, yblocks-1 do
					--love.graphics.setColor( math.max(255-RebelGrid[i][j]*1,0), math.max(255-RebelGrid[i][j]*1,0), math.max(255-RebelGrid[i][j]*1,0), 255 )
					love.graphics.setColor(255,255,255,255)
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 10) then love.graphics.draw(flag_green, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 20) then love.graphics.draw(flag_yellow, i*16, j*16) end
					if (OwnerGrid[i][j] == PlayerList[k].name and RebelGrid[i][j] >= 30) then love.graphics.draw(flag_red, i*16, j*16) end
				end
			end
		end
	end


end
