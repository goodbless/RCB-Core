
Battle = {
	tick = 0,
}

function Battle:new(player, field)
	self.__index = self
	b = setmetatable({}, self)
	b.player = player
	b.field = field
	return b
end

--Fisher–Yates shuffle
local function shuffle(cards)
	for i=#cards,1,-1 do
		local idx = math.random(1, i)
		local tmp = cards[idx]
		cards[idx] = cards[i]
		cards[i] = tmp
	end
end

local function testShuffle()
	math.randomseed(os.time())
	local order = {0,1,2,3,4,5,6,7,8,9}
	shuffle(order)
	for i,v in ipairs(order) do
		print(i,v)
	end
end

return Battle