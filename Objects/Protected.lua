#!/usr/bin/env lua

local enum = {}
setmetatable(enum, {
    __index = { A = 1, B = 2, C = 3 },
    __newindex = function (obj, k, v)
        return error("Cannot edit")
    end,
    --__tostring = function () return "Enum" end
})

print(enum.A)
print(pcall(function() enum.A = 2 end))
print(enum.A)
print(enum)
