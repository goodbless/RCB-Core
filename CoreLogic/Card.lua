
Card = {
	cardRender = nil
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

function Card:OnPlay(target)
	print("OnPlay - card:" .. card.data.name)
	if self.data.cast_time == 0 then
		self:EffectOn(target)
	else
		self.battle.player:SetIntent(self)
	end
end

function Card:EffectOn(target)
	print("Card:" .. self.data.name .. " Effect on")

end

function Card:Tick()
	self.hand_life = self.hand_life - 1
	self.cardRender:UpdateProperty("hand_life")
	if self.hand_life <= 0 then
		self:RunOutLife()
	end
end

function Card:RunOutLife()
	self.battle:Discard(self)
end

return Card