
Unit = {
	
}

function Unit:new()
	self.__index = self
	u = setmetatable({}, self)
	return u
end