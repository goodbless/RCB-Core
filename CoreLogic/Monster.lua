require "Datasheet"
require "Unit"

local function LoadMovesFromData(data)
	local moves = {}
	for _,v in ipairs(data.moves) do
		local move = LoadItem("move", v)
		table.insert(moves, move)
	end
	return moves
end

Monster = Unit:new()
Monster.hp = 1

function Monster:new(data)
	self.__index = self
	local m = setmetatable({}, self)
	m.data = data
	m.hp = data.hp
	m.toughness = data.toughness
	m.moves = LoadMovesFromData(data)
	return m
end

function Monster:TakeAtk(atk)
	if self.defence then
		atk = math.floor(atk * (1 - self.defence))
	end
	self:SubHp(atk)
end


function Monster:SubHp(value)
	self.hp = self.hp - value
	if hp <= 0 then
		self:Dead()
	end
end

function Monster:Dead()
	self.isDead = true
	print(string.format("Monster:%s(%d) dead", self.data.name, self.data.ID))
end

return Monster