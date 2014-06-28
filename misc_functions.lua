
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
