--use for:c from level.xlsx 
--ID:ID
--name:名称
--terrain:地形
--space:最大距离
--enemy:敌人配置
--ID:怪物id
--distance:初始距离

local datasheet_level = {
	[1001] = {
		ID = 1001,
		name = '教学',
		terrain = 1,
		space = 20,
		enemy = {{ID = 10002, distance = 10}, }
	}
}

return datasheet_level