
Unit = {
	
}

function Unit:new()
	self.__index = self
	local u = setmetatable({}, self)
	return u
end

function Unit:TakeAtk(atk)
	if self.defence then
		atk = math.floor(atk * (1 - self.defence))
	end
	self:SubHp(atk)
end


function Unit:SubHp(value)
	self.hp = self.hp - value
	if hp <= 0 then
		self:Dead()
	end
end

function Unit:Dead()
	self.isDead = true
end