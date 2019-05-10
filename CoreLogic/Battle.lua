require "Datasheet"
require "Card"

Battle = {
	tick = 0,
}

local LoadCardsFromWeapon
local shuffle

function Battle:new(player, field)
	self.__index = self
	b = setmetatable({}, self)
	b.player = player
	b.field = field
	b.deck = LoadCardsFromWeapon(player.weapons)
	b.hand = {}
	b.tomb = {}
	return b
end

function LoadCardsFromWeapon(weapons)
	local battleDeck = {}
	for _,w in ipairs(weapons) do
		local weaponData = LoadItem("weapon", w)
		if weaponData then
			for _,c in ipairs(weaponData.cards) do
				local cardData = LoadItem("card", c)
				local cardInBattle = Card:new(cardData)
				table.insert(battleDeck, cardInBattle)
			end
		end
	end
	shuffle(battleDeck)
	return battleDeck
end

--Fisher–Yates shuffle
function shuffle(cards)
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