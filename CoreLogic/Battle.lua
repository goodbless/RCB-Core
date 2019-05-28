require "Datasheet"
require "Card"
require "Monster"

table.removeItem = table.removeItem or function(t, item)
	for i=1,#t do
		if t[i] == item then
			table.remove(i)
			break
		end
	end
end

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


Battle = {
	tick = 0,
}

function Battle:LoadEnemyFromLevel(level)
	local enemy = {}
	for _,m in ipairs(level.enemy) do
		local monsterData = LoadItem("monster", m.ID)
		local monster = Monster:new(monsterData)
		monster.distance = m.distance
		monster.battle = battle
		table.insert(enemy, monster)
	end
	return enemy
end

function Battle:LoadCardsFromWeapon(weapons)
	local battleDeck = {}
	for _,w in ipairs(weapons) do
		local weaponData = LoadItem("weapon", w)
		if weaponData then
			for _,c in ipairs(weaponData.cards) do
				local cardData = LoadItem("card", c)
				local cardInBattle = Card:new(cardData)
				cardInBattle.battle = self
				table.insert(battleDeck, cardInBattle)
			end
		end
	end
	shuffle(battleDeck)
	return battleDeck
end

function Battle:new(player, level)
	self.__index = self
	b = setmetatable({}, self)
	b.player = player
	b.level = level
	b.enemy = b:LoadEnemyFromLevel(level)
	b.deck = b:LoadCardsFromWeapon(player.weapons)
	b.hand = {}
	b.tomb = {}
	b.queue = b:NewQueue()
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
	self:Add2Queue(function()
		card:OnPlay(target)
	end)
end

function Battle:NewQueue()
	return coroutine.create(function(action)
		repeat 
			action()
			while self.player.intent do
				self:Tick()
			end
			action = coroutine.yield()
		until false
	end)
end

function Battle:Add2Queue(action)
	if self.queue then
		coroutine.resume(self.queue, action)
	end
end

function Battle:Tick()
	self.player:Tick(self, t)
	for _,e in ipairs(self.enemy) do
		e:Tick(self)
	end

	for _,h in ipairs(self.hand) do
		h:Tick(self)
	end
end

function Battle:AddToHand(card)
	table.insert(self.hand, card)

end

function Battle:ShuffleIntoDeck(card)
	-- body
end

function Battle:AddToTomb(card)
	-- body
end

function Battle:Discard(card)
	table.removeItem(self.hand, card)
	card.cardRender:PlayDiscard()
	table.insert(self.tomb, card)
	self.battleRender:UpdateProperty("tomb.num")
end

function Battle:RandomEnemy()
	return self.enemy[math.random(#self.enemy)]
end

return Battle