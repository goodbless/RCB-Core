
Field = {
	space = 10
}

function Field:new(space)
	self.__index = self
	f = setmetatable({}, self)
	f.space = space
	return f
end

return Field