#!/usr/bin/env lua

local Warrior = require './Warrior'

return { new = function (o, name, level, weapon)
    local hunter = o or Warrior.new(o, name, level, weapon)
    local privateHunter = {}
    setmetatable(hunter, {__index=Warrior})

    hunter.name = name or hunter.name
    hunter.level = level or hunter.level
    privateHunter.weapon = weapon or hunter.weapon
    hunter.weapon = nil
    print(hunter.name .. " is born from a tree")

    function hunter:CloseAttack ()
        print(("%s strikes with his %s"):format(hunter.name, privateHunter.weapon))
    end
    function hunter:getWeapon() return privateHunter.weapon end
    function hunter:setWeapon(weapon) privateHunter.weapon = weapon end

    return hunter
end}