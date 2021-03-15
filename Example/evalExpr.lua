#! /usr/bin/env lua

--[[
    Expr = Fact ([+-] Fact)*
    Fact = Nb ([*/] Nb)*
    Nb = %d+([.]%d+)? | '(' Expr ')'
]]

local readNb
local readFact
local readExpr

readExpr = function (expr)
    local nb; nb, expr = readFact(expr)
    if nb == nil then return end

    while true do
        if expr == nil then return end

        local pass = false

        expr = expr:gsub("^%s*%+(.*)$", function (rest)
            pass = true
            local nb2, s = readFact(rest)
            if nb2 == nil then return end
            nb = nb + nb2
            return s
        end, 1)

        if not pass then
            expr = expr:gsub("^%s*%-(.*)$", function (rest)
                pass = true
                local nb2, s = readFact(rest)
                if nb2 == nil then return end
                nb = nb - nb2
                return s
            end, 1)

            if not pass then
                return nb, expr
            end
        end
    end
end

readFact = function (expr)
    local nb; nb, expr = readNb(expr)
    if nb == nil then return end

    while true do
        if expr == nil then return end

        local pass = false
        expr = expr:gsub("^%s*%*(.*)$", function (rest)
            pass = true
            local nb2, s = readNb(rest)
            if nb2 == nil then return end
            nb = nb * nb2
            return s
        end, 1)

        if not pass then
            expr = expr:gsub("^%s*/(.*)$", function (rest)
                pass = true
                local nb2, s = readNb(rest)
                if nb2 == nil then return end
                nb = nb / nb2
                return s
            end, 1)

            if not pass then
                return nb, expr
            end
        end
    end
end

readNb = function (expr)
    if expr:match("^%s*%(") then
        expr = expr:gsub("^%s*%(", "", 1)
        local nb; nb, expr = readExpr(expr)
        if nb == nil or not expr:match("^%s*%)") then return end
        expr = expr:gsub("^%s*%)", "", 1)
        return nb, expr
    else
        local nb = expr:match("^%s*%d+%.%d+")
        if nb then
            expr = expr:sub(#nb+1)
            return tonumber(nb), expr
        else
            nb = expr:match("^%s*%d+")
            if nb then
                expr = expr:sub(#nb+1)
                return tonumber(nb), expr
            end
        end
    end
end

local line = io.read()

local result; result, line = readExpr(line)
if result then
    print(result)
else
    print("Failed to parse")
end