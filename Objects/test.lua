#! /usr/bin/env lua

--local Hunter = require('./Hunter')
local Paladin = require('./Paladin')

--local elf = Hunter.new(nil, "Elf", 99, "Bow")
local paladin = Paladin.new(nil, "Human")

--elf:Heal()
paladin:Heal()