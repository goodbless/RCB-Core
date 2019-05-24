
Render = {}


function Render:new(rootObj)
	self.__index = self
	local r = setmetatable({}, self)
	r.rootObj = rootObj
	return r
end


return Render