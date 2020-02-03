local width = 3
local length = 3
local height = 3

--
-- dont edit below here
--
local durationString = function(ts)
    local s = os.clock() - ts

    local hrs = math.floor(s / 3600)
    local mins = math.floor(s / 60 - (hrs * 60))
    local secs = math.floor(s - hrs * 3600 - mins * 60)
    local dStr = 'duration:'

    dStr = ((hrs > 0) and (dStr .. ' ' .. hrs .. 'h')) or dStr
    dStr = ((mins > 0) and (dStr .. ' ' .. mins .. 'm')) or dStr
    dStr = ((secs > 0) and (dStr .. ' ' .. secs .. 's')) or dStr

    return dStr
end

local dig = function()
    while turtle.detect() do
        turtle.dig()
    end
end

local tStart = os.clock()
local up = (height > 0)
local heightAbs = math.abs(height)

-- print start info
print('digbot starting (' .. length .. 'x' .. width .. 'x' .. heightAbs .. ' ' .. (up and 'up' or 'down') .. ')')

-- farm loop
for z = 1, heightAbs do
    for y = 1, width do
        for x = 1, length do
            -- dig forward
            if x ~= length then
                dig()
                turtle.forward()
            end
        end

        -- move to next row
        if y ~= width then
            if (y % 2) == 0 then
                turtle.turnLeft()
                dig()
                turtle.forward()
                turtle.turnLeft()
            else
                turtle.turnRight()
                dig()
                turtle.forward()
                turtle.turnRight()
            end
        end
    end

    if z ~= heightAbs then
        -- move rows
        if (width % 2) ~= 0 then
            for i = 1, (length - 1) do
                turtle.back()
            end

            turtle.turnLeft()
        else
            turtle.turnRight()
        end

        -- move cells
        for i = 1, (width - 1) do
            turtle.forward()
        end

        turtle.turnRight()

        -- adjust height
        if up then
            while turtle.detectUp() do
                turtle.digUp()
            end

            turtle.up()
        else
            if turtle.detectDown() then
                turtle.digDown()
            end

            turtle.down()
        end
    end
end

-- print finished message
print('digbot finished (' .. durationString(tStart) .. ')')