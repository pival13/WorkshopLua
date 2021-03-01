local diamondLine = function (i, maxI)
    local spaces = maxI-i
    local firstLetterNb = string.byte("a")
    if i == 1 then
        return ("%s%s"):format(
            (" "):rep(spaces),
            string.char(firstLetterNb)
        )
    else
        return ("%s%s%s%s"):format(
            (" "):rep(spaces),
            string.char(firstLetterNb+i-1),
            (" "):rep((maxI-spaces-1)*2-1),
            string.char(firstLetterNb+i-1)
        )
    end
end

local diamond = function (letter)
    if not letter:match("^[a-zA-Z]$") then
        error ("Argument must be a letter")
    end

    local v = letter:lower():byte() - string.byte("a") + 1
    local tbl = {}
    for i = 1, v do
        tbl[#tbl+1] = diamondLine(i, v)
    end
    for i = v-1, 1, -1 do
        tbl[#tbl+1] = diamondLine(i, v)
    end
    return table.concat(tbl, "\n")
end

if #arg ~= 1 then error ("Expected one argument") end
local res, s = pcall(diamond, arg[1])
if res then
    print(s)
else
    io.stderr:write(s)
end