
Player = Unit:new()
Player.max_hand = 5

function Player:new()
	self.__index = self
	p = setmetatable({}, self)
	equips = {}
	return p
end

return Player
