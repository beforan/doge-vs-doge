--a container class for helper functions

local utils = {}

function utils.getDogeism()
	local dogeisms = {
		"such", "very", "many", "much", "so"
	}
	return dogeisms[math.random(#dogeisms)]
end

return utils