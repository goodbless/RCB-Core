require "Render"

BattleRender = Render:new()

function BattleRender:new(rootObj)
	return setmetatable({}, Render:new)
	-- body
end

function BattleRender:( ... )
	-- body
end