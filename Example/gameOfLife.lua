local draw = function (tbl)
    for _, row in ipairs(tbl) do
        print(row)
    end
end

local gameOfLife = function (map, iter)
    local sizeY = #map
    local sizeX = #map[1]
    for _, row in ipairs(map) do if #row ~= sizeX then error() end end
    iter = iter or 10

    for it = 1, iter do
        local newmap = {}
        for i = 1, sizeY do
            newmap[i] = {}
            for j = 1, sizeX do
                local count = 0
                if i > 1 and j > 1 and map[i-1]:sub(j-1, j-1) == "." then
                    count = count+1
                end
                if i > 1 and map[i-1]:sub(j, j) == "." then
                    count = count+1
                end
                if i > 1 and j < sizeX and map[i-1]:sub(j+1, j+1) == "." then
                    count = count+1
                end
                if j > 1 and map[i]:sub(j-1, j-1) == "." then
                    count = count+1
                end
                if j < sizeX and map[i]:sub(j+1, j+1) == "." then
                    count = count+1
                end
                if i < sizeY and j > 1 and map[i+1]:sub(j-1, j-1) == "." then
                    count = count+1
                end
                if i < sizeY and j < sizeX and map[i+1]:sub(j+1, j+1) == "." then
                    count = count+1
                end
                if i < sizeY and map[i+1]:sub(j, j) == "." then
                    count = count+1
                end
                newmap[i][j] = count == 3 and "." or count == 2 and map[i]:sub(j, j) or " "
            end
            newmap[i] = table.concat(newmap[i], "")
        end
        map = newmap
        draw(map)
        print("==================================================")
    end
    return map
end

gameOfLife{
    " .             ",
    "  .     .      ",
    "...      .     ",
    "       ...     ",
    "               ",
    "               "
}