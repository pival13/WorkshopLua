#!/usr/bin/env lua
--print(myLs())

local luaLs = function (path)
    print(path)
    for dir in io.popen(("ls %s"):format(path or "")):lines() do
        print("  " .. dir)
    end
end

luafunction = function (truc)
    print(truc)
    print()
    truc = "../"
    myLs(truc)
    print()
    luaLs(truc)
end