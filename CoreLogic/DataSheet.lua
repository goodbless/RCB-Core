
local data_dir = "Data/"

function LoadItem(sheet, id)
	local dataSheet = require(data_dir .. sheet)
	if dataSheet then
		return dataSheet[id]
	end
	return nil
end

function LoadSheet(sheet)
	return require(data_dir ..sheet)
end