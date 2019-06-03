--use for:c from monster.xlsx 
--ID:ID
--name:名称
--hp:生命值
--moves:攻击动作

local datasheet_monster = {
	[10001] = {
		ID = 10001,
		name = '史莱姆',
		hp = 12,
		toughness = 3,
		moves = {100010, }
	},
	[10002] = {
		ID = 10002,
		name = '活尸',
		hp = 20,
		toughness = 3,
		moves = {100020, }
	},
	[10003] = {
		ID = 10003,
		name = '活尸士兵',
		hp = 30,
		toughness = 4,
		moves = {100030, 100031, }
	},
	[10004] = {
		ID = 10004,
		name = '活尸狗',
		hp = 8,
		toughness = 2,
		moves = {100040, }
	}
}

return datasheet_monster