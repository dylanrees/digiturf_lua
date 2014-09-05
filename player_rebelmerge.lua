--contains everything relating to rebellion and merging for the player

--REBELLION-RELATED STUFF DOWN HERE.
    
    function Player.GetRebelRanking (self) --monitors color variation in a player's territory for rebellion purposes
    	local myland = {}
    	local meancolor = {}; meancolor[0]=0; meancolor[1]=0; meancolor[2]=0
    	local landcounter = 0
		for i=0, xblocks-1 do
			for j=0, yblocks-1 do
				if (OwnerGrid[i][j] == self.name) then 
					landcounter = landcounter + 1
					table.insert(myland, {i,j})
					meancolor[0] = meancolor[0] + ColorGrid[i][j][0]
					meancolor[1] = meancolor[1] + ColorGrid[i][j][1]
					meancolor[2] = meancolor[2] + ColorGrid[i][j][2]
				end
			end
		end
		meancolor[0] = meancolor[0]/landcounter
		meancolor[1] = meancolor[1]/landcounter
		meancolor[2] = meancolor[2]/landcounter
		local variation = 0
		for i=1, table.getn(myland) do
			variation = variation + math.abs(meancolor[0]-ColorGrid[myland[i][1]][myland[i][2]][0]) + math.abs(meancolor[1]-ColorGrid[myland[i][1]][myland[i][2]][1]) + math.abs(meancolor[2]-ColorGrid[myland[i][1]][myland[i][2]][2])
		end
		result = variation/landcounter
		return result
    end

    function Player.GetRebelLocus (self) --returns square in the territory that is farthest from mean color
    	local myland = {}
    	meancolor = {}; meancolor[0]=0; meancolor[1]=0; meancolor[2]=0
    	local landcounter = 0
		for i=0, xblocks-1 do
			for j=0, yblocks-1 do
				if (OwnerGrid[i][j] == self.name) then 
					landcounter = landcounter + 1
					table.insert(myland, {i,j})
					meancolor[0] = meancolor[0] + ColorGrid[i][j][0]
					meancolor[1] = meancolor[1] + ColorGrid[i][j][1]
					meancolor[2] = meancolor[2] + ColorGrid[i][j][2]
				end
			end
		end
		meancolor[0] = meancolor[0]/landcounter
		meancolor[1] = meancolor[1]/landcounter
		meancolor[2] = meancolor[2]/landcounter
		local choice = myland[1]
		if (landcounter >= 1) then --only continue the rest if the player has more than once square
			local variation1 = 0; local variation2 = 0
			for i=1, table.getn(myland) do
				variation1 = math.abs(meancolor[0]-ColorGrid[myland[i][1]][myland[i][2]][0]) + math.abs(meancolor[1]-ColorGrid[myland[i][1]][myland[i][2]][1]) + math.abs(meancolor[2]-ColorGrid[myland[i][1]][myland[i][2]][2])
				variation2 = math.abs(meancolor[0]-ColorGrid[choice[1]][choice[2]][0]) + math.abs(meancolor[1]-ColorGrid[choice[1]][choice[2]][1]) + math.abs(meancolor[2]-ColorGrid[choice[1]][choice[2]][2])
				if ((variation1>=variation2 and variation1>=12) or variation1>42) then choice = myland[i] end
			end
		end
		return choice
    end

	function Player.RebellionSort(self) --checks to see whether a rebellion should happen
	--	local locus = self.GetRebelLocus(self)
	--	local RebellionFlag = false --flagged as true to trigger a rebellion
	--		RebelColors = {} ; RebelColors[0] = ColorGrid[locus[1]][locus[2]][0] ; RebelColors[1] = ColorGrid[locus[1]][locus[2]][1] ; RebelColors[2] = ColorGrid[locus[1]][locus[2]][2]
	--		for i = 0, xblocks-1 do
	--			for j = 0, yblocks-1 do
	--				local DiffToMain = math.abs(ColorGrid[i][j][0] - meancolor[0]) + math.abs(ColorGrid[i][j][1] - meancolor[1]) + math.abs(ColorGrid[i][j][2] - meancolor[2])
	--				local DiffToLocus = math.abs(ColorGrid[i][j][0] - RebelColors[0]) + math.abs(ColorGrid[i][j][1] - RebelColors[1]) + math.abs(ColorGrid[i][j][2] - RebelColors[2])
	--				if (DiffToMain>=DiffToLocus and (DiffToMain>8 or DiffToLocus>8)) then RebelGrid[i][j] = RebelGrid[i][j]+0.15 else RebelGrid[i][j] = math.max(RebelGrid[i][j]-1,0) end
	--				if (RebelGrid[i][j]>=40) then RebellionFlag = true end
	--			end
	--		end
	--	if (RebellionFlag == true) then self.rebellion(self) end
		return RebelGrid
	end	

	function Player.rebellion(self) --actually cleaves off the new piece of territory
		local switch = false --changes behavior after the first cleaving territory is identified
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				if (RebelGrid[i][j] >= 30 and OwnerGrid[i][j] == self.name) then --only the first square needs to be 40 rebelgrid; the rest get "carried along"
					if (switch == false) then
						switch = true
						reddelta = love.math.random(60)-30
						greendelta = love.math.random(60)-30
						bluedelta = love.math.random(60)-30
						rebelplayer = maingame.CreateAnonPlayer(i,j,ColorGrid[i][j][0]+reddelta,ColorGrid[i][j][1]+greendelta,ColorGrid[i][j][2]+bluedelta)
						rebelplayer.cityx = self.cityx --let the new player inherit the old player's city properties
						rebelplayer.cityy = self.cityy
						rebelplayer.cityquad = love.graphics.newQuad(rebelplayer.cityx*16,rebelplayer.cityy*16,16,16, cityImage:getDimensions())	
						rebelplayer.littlecityx = self.littlecityy
						rebelplayer.littlecityy = self.littlecityy
						rebelplayer.littlecityquad = love.graphics.newQuad(rebelplayer.littlecityx*16,rebelplayer.littlecityy*16,16,16, littlecityImage:getDimensions())
					else
						OwnerGrid[i][j]=rebelplayer.name  --next 4 lines give territory to the new player and turn it their color
						ColorGrid[i][j][0]=ColorGrid[i][j][0]+reddelta
						ColorGrid[i][j][1]=ColorGrid[i][j][1]+greendelta
						ColorGrid[i][j][2]=ColorGrid[i][j][2]+bluedelta
					end
					RebelGrid[i][j]=0
				end
			end
		end
		maingame.PlayerCleanup(maingame) --cleanup
		if (switch==true) then love.audio.play(rebellionsound) end
	end
	
	function Player.PickNewTown(self) --finds a new town location for a player whose town space has been stolen
		local pick = {} --this variable stores the coordinates of the chosen square
		local pickroll = 0--stores the random number
		local pickrollnew = 0
		for i = 0, xblocks-1 do
			for j = 0, yblocks-1 do
				pickrollnew = love.math.random(9999)+1
				if (pickrollnew >= pickroll and OwnerGrid[i][j] == self.name) then
					pickroll = pickrollnew
					pick[1] = i
					pick[2] = j
				end
			end
		end
		self.originx = pick[1]
		self.originy = pick[2]
	end

