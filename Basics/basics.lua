#! /usr/bin/env lua

local printTable = function (args)
    local tbl = args.table or args[1] or {}
    local first = args.begin or 1
    local last = args["end"] or #tbl

    for i = first, last do
        io.write(tostring(tbl[i]) .. " ")
    end
    print()
end

printTable{ table = {1, 2, 3, 4, 5, 6, 7, 8} }
printTable{ table = {1, 2, 3, 4, 5, 6, 7, 8}, begin = 6 }
printTable{ {1, 2, 3, 4, 5, 6, 7, 8}, begin = 1, ['end'] = 4 }
