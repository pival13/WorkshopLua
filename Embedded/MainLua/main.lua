#! /usr/bin/env lua

if arg and debug.getinfo(1).short_src == arg[0] then
    os.execute("gcc -fPIC -shared ./libTest.c -o ./test.so")

    local test = require 'test'

    for k, v in pairs(test.ls(".")) do
        print(k, v)
    end

    os.execute("rm -f ./test.so")
end
