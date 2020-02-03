local width = 4
local length = 4
local height = 4
local dropItems = true

--
-- dont edit below here
--
local tStart = os.clock()
local up = (height > 0)
local heightAbs = math.abs(height)

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
    if turtle.detect() then
        turtle.dig()
    end
end

print('digging started (' .. length .. 'x' .. width .. 'x' .. height .. ')')

-- farm loop
for z = 1, heightAbs do
    for y = 1, width do
        for x = 1, length do
            if x ~= length then
                dig()
                turtle.forward()
            end
        end

        -- move to next row
        if y ~= width then
            if (z % 2) == 0 then
                if (y % 2) == 0 then
                    turtle.turnRight()
                    dig()
                    turtle.forward()
                    turtle.turnRight()
                else
                    turtle.turnLeft()
                    dig()
                    turtle.forward()
                    turtle.turnLeft()
                end
            else
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
    end

    if z ~= heightAbs then
        turtle.turnLeft()
        turtle.turnLeft()

        if up then
            if turtle.detectUp() then
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

-- move into right height
for i = 1, (heightAbs - 1) do
    if up then
        turtle.down()
    else
        turtle.up()
    end
end

-- move back if ended on uneven row
if (width % 2) ~= 0 then
    for i = 1, (length - 1) do
        turtle.back()
    end

    turtle.turnLeft()
else
    turtle.turnRight()
end

-- move cells down
for i = 1, (width - 1) do
    turtle.forward()
end

if dropItems then -- drop items
    turtle.turnLeft()

    -- try drop all slots
    for i = 1, 16 do
        if turtle.getItemCount(i) > 0 then
            turtle.select(i)

            if not turtle.drop() then
                print('warning: failed to drop items. (inventory full?)')
                break
            end
        end
    end

    turtle.turnRight()
    turtle.turnRight()
else -- turn into start pos
    turtle.turnRight()
end

-- calculate duration
print('digging finished (' .. durationString(tStart) .. ')')
