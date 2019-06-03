--use for:c from monster.xlsx 
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

local datasheet_move = {
	[100010] = {
		ID = 100010,
		name = '粘液',
		cast_time = 3,
		tenacity = 2,
		range = 2,
	},
	[100020] = {
		ID = 100020,
		name = '扑咬',
		cast_time = 3,
		tenacity = 5,
		range = 1,
	},
	[100030] = {
		ID = 100030,
		name = '攻击',
		cast_time = 3,
		tenacity = 10,
		range = 1,
	},
	[100031] = {
		ID = 100031,
		name = '举盾',
		def = 0.75,
	},
	[100040] = {
		ID = 100040,
		name = '撕咬',
		cast_time = 2,
		tenacity = 5,
		range = 1,
	}
}

return datasheet_move