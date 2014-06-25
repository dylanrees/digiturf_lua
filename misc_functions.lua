
function IsSolid (xpos, ypos) --looks at the Hazard Grid to tell you whether a given space is a solid, i.e. impassalbe
	answer = false
	SolidTable = {"water", "chaos"} -- this table contains the names of all the solid hazards
	for i = 1, table.getn(SolidTable) do 
		if (HazardGrid[xpos][ypos] == SolidTable[i]) then answer = true end
	end
	return answer
end
