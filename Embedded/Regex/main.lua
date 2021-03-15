#! /usr/bin/env lua

local re = require 'regex'

local m = re.match("(\\w+) (\\d+)", "Hello_world 42")
print(m:span(2))