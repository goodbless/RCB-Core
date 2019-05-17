require "Datasheet"
require "Card"
require "Monster"

--Fisher–Yates shuffle
local function shuffle(cards)
	for i=#cards,1,-1 do
		local idx = math.random(1, i)
		cards[idx], cards[i] = cards[i], cards[idx]
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

local function LoadEnemyFromLevel(level)
	local enemy = {}
	for _,m in ipairs(level.enemy) do
		local monsterData = LoadItem("monster", m.ID)
		local monster = Monster:new(monsterData)
		monster.distance = m.distance
		table.insert(enemy, monster)
	end
	return enemy
end

local function LoadCardsFromWeapon(weapons)
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

Battle = {
	tick = 0,
}

function Battle:new(player, level)
	self.__index = self
	b = setmetatable({}, self)
	b.player = player
	b.level = level
	b.enemy = LoadEnemyFromLevel(level)
	b.deck = LoadCardsFromWeapon(player.weapons)
	b.hand = {}
	b.tomb = {}
	return b
end

function Battle:Draw(n)
	n = n or 1
	if n <= 0 or #self.hand >= self.player.max_hand then
		return
	end
	if #self.deck > 0 then
		local draw_card = table.remove(self.deck)
		draw_card:OnDraw()
		table.insert(self.hand, draw_card)
	elseif #self.tomb > 0 then
		self.deck = self.tomb
		self.tomb = {}
		shuffle(self.deck)
	end
	self:Draw(n-1)
end

function Battle:PlayCard(card, target)
	
end

function Battle:Tick(t)
	for _,h in ipairs(self.hand) do
		h:Tick(self, t)
	end
	self.player:Tick(self, t)
	for _,e in ipairs(self.enemy) do
		e:Tick(self, t)
	end
end

return Battle