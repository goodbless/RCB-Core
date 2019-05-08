require "Battle"
require "Player"
require "Field"
require "DataSheet"

math.randomseed(os.time())

local player = Player:new()

player.weapons = {101, 101, 1001, 2001}

local field = Field:new(10)

local battle = Battle:new(player, field)
print_r(battle)