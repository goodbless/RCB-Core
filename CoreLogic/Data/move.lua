--use for:c from monster.xlsx 
--ID:ID
--name:名称
--cast:施法时间
--last:持续时间
--dmg:伤害
--range:攻击距离
--def:防御

local datasheet_move = {
	[100010] = {
		ID = 100010,
		name = '粘液',
		cast = 3,
		dmg = 2,
		range = 2,
	},
	[100020] = {
		ID = 100020,
		name = '扑咬',
		cast = 3,
		dmg = 5,
		range = 1,
	},
	[100030] = {
		ID = 100030,
		name = '攻击',
		cast = 3,
		dmg = 10,
		range = 1,
	},
	[100031] = {
		ID = 100031,
		name = '举盾',
		def = 0.75
	},
	[100040] = {
		ID = 100040,
		name = '撕咬',
		cast = 2,
		dmg = 5,
		range = 1,
	}
}

return datasheet_move