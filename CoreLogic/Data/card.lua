--use for:c from card.xlsx 
--ID:ID
--name:名称
--cast_time:吟唱时间
--hand_life:手牌寿命
--tenacity:韧性
--target:目标类型
--range:攻击距离
--repeat_time:重复次数
--shift:位移
--atk:伤害
--def:防御
--hp_change:自身血量改变
--impact:冲击
--slow:缓慢
--heavy:难行
--class:实例化类型
--visual:视效
--audio:音效

local datasheet_card = {
	[10101] = {
		ID = 10101,
		name = '平砍',
		cast_time = 1,
		hand_life = 3,
		tenacity = 0,
		target = 1,
		range = 3,
		shift = -1,
		atk = 5,
	},
	[10102] = {
		ID = 10102,
		name = '蓄力刺',
		cast_time = 2,
		hand_life = 3,
		tenacity = 1,
		target = 1,
		range = 4,
		shift = -2,
		atk = 12,
	},
	[10103] = {
		ID = 10103,
		name = '二连刺',
		cast_time = 1,
		hand_life = 3,
		tenacity = 0,
		range = 3,
		repeat_time = 2,
		atk = 3,
	},
	[100101] = {
		ID = 100101,
		name = '格挡',
		cast_time = 1,
		hand_life = 3,
		tenacity = 5,
		def = 0.75,
	},
	[100102] = {
		ID = 100102,
		name = '盾牌冲撞',
		cast_time = 1,
		hand_life = 3,
		tenacity = 3,
		target = 1,
		range = 1,
		impact = 3,
	},
	[200101] = {
		ID = 200101,
		name = '翻滚',
		cast_time = 1,
		hand_life = 2,
		shift = 3,
	},
	[200102] = {
		ID = 200102,
		name = '大跳',
		cast_time = 2,
		hand_life = 3,
		shift = 5,
	}
}

return datasheet_card