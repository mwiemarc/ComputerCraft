local args = {...}

if #args ~= 3 then
    print('usage: dig <length> <width> <height>')
    return
end

local length = tonumber(args[1])
local width = tonumber(args[2])
local height = tonumber(args[3])

local durationString = function(ts)
    local s = os.clock() - ts

    local hrs = math.floor(s / 3600)
    local mins = math.floor(s / 60 - (hrs * 60))
    local secs = math.floor(s - hrs * 3600 - mins * 60)
    local dStr = ''

    dStr = ((hrs > 0) and (dStr .. ' ' .. hrs .. 'h')) or dStr
    dStr = ((mins > 0) and (dStr .. ' ' .. mins .. 'm')) or dStr
    dStr = ((secs > 0) and (dStr .. ' ' .. secs .. 's')) or dStr

    if dStr == '' then
        dStr = ' -'
    end

    return dStr
end

local dig = function()
    while turtle.detect() do
        turtle.dig()

        sleep(0.25)
    end
end

local digUp = function()
    while turtle.detectUp() do
        turtle.digUp()

        sleep(0.25)
    end
end

local digDown = function()
    if turtle.detectDown() then
        turtle.digDown()
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
            -- dig
            if z ~= heightAbs then
                digUp()
            end

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

        -- move to next level
        if up then
            digUp()
            turtle.up()
        else
            digDown()
            turtle.down()
        end
    end
end

-- print finished message
print('digbot finished (duration:' .. durationString(tStart) .. ')')
