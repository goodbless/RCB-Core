
Player = Unit:new()
Player.max_hand = 5

function Player:new()
	self.__index = self
	local p = setmetatable({}, self)
	equips = {}
	return p
end

function Player:SetIntent(card, target)
	self.intent = {
		countDown = card.cast_time,
		card = card,
		target = target
	}
end

function Player:Tick()
	if self.intent then
		self.intent.countDown = self.intent.countDown - 1
		if self.intent.countDown <= 0 then
			self.intent.card:EffectOn(self.intent.target)
			self.intent = nil
		end
	end
end

function Player:HpChange(value)
	if value > 0 then
		--heal
	elseif value < 0 then
		--damage
	end
end

return Player
