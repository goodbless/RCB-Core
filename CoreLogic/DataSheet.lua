
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

function print_r (t,showrepeat)  
    local print_r_cache={}
    print_r_cache[tostring(t)]=not showrepeat
    local function sub_print_r(t,indent)
        if (type(t)=="table") then
            for pos,val in pairs(t) do
                if (type(val)=="table") then
                    if (print_r_cache[tostring(val)]) then
                        print(indent.."["..pos.."] => ".."*"..tostring(val))
                    else
                        print_r_cache[tostring(val)]=not showrepeat
                        print(indent.."["..pos.."] => "..tostring(val).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    end
                elseif (type(val)=="string") then
                    print(indent.."["..pos..'] => "'..val..'"')
                else
                    print(indent.."["..pos.."] => "..tostring(val))
                end
            end
        else
            print(indent..tostring(t))
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end