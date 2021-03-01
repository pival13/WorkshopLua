#!/usr/bin/env lua

local Chara = require './Character'

local Warrior = {
    level = 42,
}
setmetatable(Warrior, {__index=Chara})

function Warrior:new (name, level, weapon)
    local warrior = self or Chara.new(self, name, level)
    setmetatable(warrior, {__index=Warrior})

    warrior.name = name or warrior.name
    warrior.level = level or warrior.level
    warrior.weapon = weapon or "Fists"
    print(("I'm %s KKKKRRRRREEEEEOOOORRRRGGGG"):format(warrior.name))
    return warrior
end

function Warrior:Heal ()
    Chara.Heal(self)
end

return Warrior