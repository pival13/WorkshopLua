local getNeighbour = function (map, x, y)
    local count = 0
    for i = math.max(y-1, 1), math.min(y+1, #map) do
        for j = math.max(x-1, 1), math.min(x+1, #map[i]) do
            if map[i][j] == "*" then
                count = count + 1
            end
        end
    end
    return count
end

local function minesweeper (file)
    local fd = assert(io.open(file))
    local map = {}
    for line in fd:lines() do
        line = {string.rep("c1", #line):unpack(line)}
        line[#line] = nil
        for _, c in ipairs(line) do if not c:match("[* ]") then error("Invalid file: unknow character " .. c) end end
        if #map == 0 then
            map[1] = line
        elseif #map[1] ~= #line then
            error("Invalid file: all lines does not have the same length")
        else
            map[#map+1] = line
        end
    end

    for i, row in ipairs(map) do
        for j, cell in ipairs(row) do if cell ~= "*" then
            local count = getNeighbour(map, j, i)
            map[i][j] = count ~= 0 and string.format("%d", count) or " "
        end end
    end
    for i, row in ipairs(map) do
        map[i] = table.concat(row, "")
    end
    return table.concat(map, "\n")
end

local success, txt = pcall(minesweeper, "mines.txt")
if not success then
    io.stderr:write(txt.."\n")
else
    print(txt)
end