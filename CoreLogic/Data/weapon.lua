--use for:c from weapon.xlsx 
--ID:ID
--name:名称
--cards:卡牌

local datasheet_weapon = {
	[101] = {
		ID = 101,
		name = '直剑',
		cards = {10101, 10101, 10101, 10102, }
	},
	[1001] = {
		ID = 1001,
		name = '木盾',
		cards = {100101, 100101, 100101, 100102, }
	},
	[2001] = {
		ID = 2001,
		name = '靴子',
		cards = {200101, 200101, 200101, 200102, }
	}
}

return datasheet_weapon