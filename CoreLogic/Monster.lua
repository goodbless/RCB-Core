
Monster = {
	hp = 1
}

function Monster:new(data)
	self.__index = self
	m = setmetatable({}, self)
	m.data = data
	return m
end

return Monster