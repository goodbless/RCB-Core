
Card = {

}

function Card:new(data)
	self.__index = self
	c = setmetatable({}, self)
	c.data = data
	return c
end

function Card:OnDraw()
	self.hand_life = self.data.hand_life
end

return Card