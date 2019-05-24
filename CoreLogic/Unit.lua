
Unit = {
	
}

function Unit:new()
	self.__index = self
	local u = setmetatable({}, self)
	return u
end