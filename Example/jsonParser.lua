local parseJson;

local parseString = function (json)
    local v, rest = json:match([[^%s*"([^"]*)"(.*)]])
    if v then
        return v, rest
    else
        return nil, "Fail to parse a string"
    end
end

local parseObject = function (json)
    local json2 = json:match("^%s*%{(.*)")
    local tbl = {}
    local first = true
    while not json2:match("^%s*%}") do
        if not first then
            json2 = json2:match("^%s*,%s*(.*)")
            if not json2 then return nil, "Fail to parse a comma" end
        else first = false end
        local k, v;
        k, json2 = parseString(json2)
        if not k then return nil, "Fail to parse a key" end
        json2 = json2:match("^%s*:%s*(.*)")
        if not json2 then return nil, "Fail to parse a colon" end
        v, json2 = parseJson(json2)
        if not v then return nil, "Fail to parse an object-value" end
        tbl[k] = v
    end
    return tbl, json2:match("^%s*%}(.*)")
end

local parseList = function (json)
    local json2 = json:match("^%s*%[(.*)")
    local tbl = {}
    local first = true
    while not json2:match("^%s*%]") do
        if not first then
            json2 = json2:match("^%s*,%s*(.*)")
            if not json2 then return nil, "Fail to parse a comma" end
        else first = false end
        local v; v, json2 = parseJson(json2)
        if not v then return nil, "Fail to parse a list-value" end
        tbl[#tbl+1] = v
    end
    return tbl, json2:match("^%s*%](.*)")
end

parseJson = function (json)
    if json:match("^%s*%{") then
        return parseObject(json)
    elseif json:match("^%s*%[") then
        return parseList(json)
    elseif json:match("^%s*\"") then
        return parseString(json)
    elseif json:match("^%s*%-?%d") then
        local v, rest = json:match("^%s*(%-?%d+%.%d+)(.*)")
        if not v then v, rest = json:match("^%s*(%-?%d+)(.*)") end
        return tonumber(v), rest
    elseif json:match("^%s*true") then
        return true, json:match("^%s*true(.*)")
    elseif json:match("^%s*false") then
        return false, json:match("^%s*false(.*)")
    elseif json:match("^%s*null") then
        return nil, json:match("^%s*null(.*)")
    end
    return nil, json
end

local jsonParser = function (filepath)
    local f = io.open(filepath, "r")
    if not f then return end
    local content = f:read("a")
    local obj; obj, content = parseJson(content)
    if not content:match("^%s*$") then return nil, content end
    return obj, content
end

local printObject; printObject = function (obj, indentSize)
    indentSize = indentSize or 0
    local s = ''
    for i = 1, indentSize do s = s .. ' ' end
    if type(obj) == "table" then
        print("{")
        for i, j in pairs(obj) do
            io.write(s .. '  ' .. tostring(i) .. ' = ')
            printObject(j, indentSize + 2)
        end
        print(s .. "}")
    else
        print(tostring(obj))
    end
end

printObject(jsonParser("a.json"))