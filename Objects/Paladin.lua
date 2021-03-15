#!/usr/bin/env lua

local Warrior = require './Warrior'
local Priest = require './Priest'

local Paladin = {}

local inheritRules = function (object, key)
    if key == "Heal" then
        return Priest[key]
    else
        return Warrior[key] or Priest[key]
    end
end
setmetatable(Paladin, {__index = inheritRules})

function Paladin.new (o, name, level, weapon)
    local p = o or {
        name = name,
        level = level,
        weapon = weapon
    }
    setmetatable(p, {__index=Paladin})
    print("The light fall on " .. p.name)
    return p
end

return Paladin