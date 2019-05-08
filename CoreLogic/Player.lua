
Player = {
	equips = {},
}

function Player:new()
	self.__index = self
	p = setmetatable({}, self)
	return p
end

return Player
