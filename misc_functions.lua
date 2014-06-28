
function IsSolid (xpos, ypos) --looks at the Hazard Grid to tell you whether a given space is a solid, i.e. impassalbe
	local answer = false
	SolidTable = {"water", "chaos", "lava"} -- this table contains the names of all the solid hazards
	for i = 1, table.getn(SolidTable) do 
		if (HazardGrid[xpos][ypos] == SolidTable[i]) then answer = true end
	end
	return answer
end

function GetDepop (xpos, ypos) --looks at the Hazard Grid to tell you whether a given space has the depop property
	local answer = 0
	DepopTable = {{"lava",15},{"radioactive",30}} -- this table contains the names of all the depop hazards and their depop levels
	for i = 1, table.getn(DepopTable) do
		if (HazardGrid[xpos][ypos] == DepopTable[i][1]) then answer = DepopTable[i][2] end
	end
	return answer
end

function depop(xpos,ypos) -- depopulates a game square, returning it to non-ownership
	OwnerGrid[xpos][ypos]="nobody"
	ColorGrid[xpos][ypos][0] = 50
	ColorGrid[xpos][ypos][1] = 50
	ColorGrid[xpos][ypos][2] = 50
end

function GetStability (xpos, ypos) --looks at the Hazard Grid to tell you how much random color-changing will happen on a spot
	local answer = 1 --by default, the coefficient is unity. higher value = more unstable
	StabileTable = {{"forest",0.5}} --all hazards with non-unity stability
	for i = 1, table.getn(StabileTable) do
		if (HazardGrid[xpos][ypos] == StabileTable[i][1]) then answer = StabileTable[i][2] end
	end
	return answer
end

function GetGrabCost (xpos, ypos) --looks at the Hazard Grid to tell you how hard it is to grab unowned land
	local answer = 15 --default value.  this is the number of "action points" you need to claim it
	CostTable = {{"forest",30}} --all hazards with non-default grab cost
	for i = 1, table.getn(CostTable) do
		if (HazardGrid[xpos][ypos] == CostTable[i][1]) then answer = CostTable[i][2] end
	end
	return answer
end
