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

return Paladin