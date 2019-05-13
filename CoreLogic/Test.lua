require "Battle"
require "Player"
require "Field"
require "DataSheet"

math.randomseed(os.time())

local player = Player:new()

player.weapons = {101, 101, 1001, 2001}

local level = LoadItem("level", 1001)

local battle = Battle:new(player, level)
print_r(battle)