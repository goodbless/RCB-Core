require "Battle"
require "Player"
require "Field"
require "DataSheet"


local player = Player:new()

player.weapons = {101, 101, 1001, 2001}

local field = Field:new(10)

local battle = Battle:new(player, field)

local cardSheet = require "Data/card"
for i,v in pairs(cardSheet) do
	print(i,v)
end

local item = LoadItem("card", 10101)
for i,v in pairs(item) do
	print(i,v)
end