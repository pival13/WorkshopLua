#!/usr/bin/env lua

local Character = {
    name = "Keorg",
    level = 1,
    mp = 100,
    hp = 100
}

function Character.new(o, name, level)
    local chara = o or {}
    for k, v in pairs(Character) do
        if not chara[k] then
            chara[k] = v
        end
    end
    setmetatable(chara, getmetatable(Character))
    chara.name = name or chara.name
    chara.level = level or chara.level
    print(chara.name .. " created")
    return chara
end

function Character:getName()
    return self.name
end

function Character:Heal()
    if self.hp <= 0 then
        print(self.name .. " out of combat")
        return
    end

    local cost = 0
    if self.mp > cost then
        self.mp = math.max(self.mp - cost, 0)
        self.hp = math.min(self.hp + 50, 100)
        print(self.name .. " takes a potion")
    else
        print(self.name .. " out of power")
    end
end

return Character