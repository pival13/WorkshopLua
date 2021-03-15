#! /usr/in/env lua

local Chara = require './Character'

local Priest = {}
setmetatable(Priest, {__index=Chara})

function Priest.new (o, name, level)
    local p = o or Chara.new(o, name, level)
    setmetatable(p, {__index=Priest})

    print(p.name .. " enters in the order")
    return p
end

function Priest:Heal ()
    if self.hp <= 0 then
        print(self.name .. " out of combat")
        return
    end

    local cost = 10
    if self.mp > cost then
        self.mp = math.max(self.mp - cost, 0)
        self.hp = math.min(self.hp + 70, 100)
        print(self.name .. " cast a little heal spell")
    else
        print(self.name .. " out of power")
    end
end

return Priest