
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

function Unit:TakeImpact(impact)
	self.impact = self.impact or 0 + impact
	if not self.intent.tenacity then return end
	local 
	if self.impact > self.intent.tenacity then
		self:Stagger(impact)
	end
end

function Unit:Stagger(impact)
	self.intent = {
		countDown = impact
	}
end