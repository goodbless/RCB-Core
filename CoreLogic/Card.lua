
CardTargetType = {
	Player = 0,
	Individual = 1,
	AOE = 2,
	Random = 3
}

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
		self:TakeEffect(target)
	else
		self.battle.player:SetIntent(self)
	end
end

function Card:TakeEffect(target)
	print("Card:" .. self.data.name .. " Effect on")
	local repeatNum = self.data.repeat or 1
	local cardD = self.data
	local player = self.battle.player
	if not player or player.isDead then return end

	if cardD.target == CardTargetType.Individual
		if not target then return end
		if target.distance > cardD.range then
			self.battle:UpdateDistanceBy(cardD.range - target.distance)
		end
	end

	for i=1, repeatNum do
		if cardD.target == CardTargetType.Random then
			target = self.battle:RandomEnemy()
		end
		
		local shift = self.shift or cardD.shift
		if shift then self.battle:UpdateDistanceBy(shift) end
		if cardD.hp_change then player:HpChange(cardD.hp_change) end

		if not player or player.isDead then return end

		if cardD.target == CardTargetType.AOE then
			for i,e in ipairs(self.battle.enemy) do
				self:EffectOn(cardD, player, e)
			end
		elseif target and not target.isDead then
			self:EffectOn(cardD, player, target)
		end
	end

end

function Card:EffectOn(cardD, player, target)

	local atk = self.atk or cardD.atk
	if cardD.atk then 
		target:TakeAtk(atk) 
		if not target or target.isDead then return end
	end

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