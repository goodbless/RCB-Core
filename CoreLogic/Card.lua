
Card = {
	
}

function Card:new(data)
	self.__index = self
	c = setmetatable({}, self)
	c.data = data
	return c
end

return Card