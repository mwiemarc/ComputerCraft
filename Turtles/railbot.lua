local railLength = 27
local poweredLength = 9

-- :: predefined item stack positions ::
-- slot 1: rail
-- slot 2: powered rail
-- slot 15: common floor block
-- slot 16: redstone torch

-- don't edit below here

local durationTime = function(ts)
    local s = os.clock() - ts

    local hrs = math.floor(s / 3600)
    local mins = math.floor(s / 60 - (hrs * 60))
    local secs = math.floor(s - hrs * 3600 - mins * 60)
    local dStr = ''

    dStr = ((hrs > 0) and (dStr .. ' ' .. hrs .. 'h')) or dStr
    dStr = ((mins > 0) and (dStr .. ' ' .. mins .. 'm')) or dStr
    dStr = ((secs > 0) and (dStr .. ' ' .. secs .. 's')) or dStr

    return dStr
end

local function fillInventorySlot(slot)
    turtle.select(slot)

    for i = 1, 16 do
        if i ~= slot and turtle.compareTo(i) then
            turtle.select(i)
            turtle.transferTo(slot)
            break
        end
    end
end

local function checkInventoryItems()
    local rCount = turtle.getItemCount(1)
    local pCount = turtle.getItemCount(2)
    local bCount = turtle.getItemCount(15)
    local tCount = turtle.getItemCount(16)

    if rCount < 1 then
        return false
    elseif rCount == 1 then
        fillInventorySlot(1)
    end

    if pCount < 1 then
        return false
    elseif pCount == 1 then
        fillInventorySlot(2)
    end

    if bCount < 1 then
        return false
    elseif bCount == 1 then
        fillInventorySlot(15)
    end

    if tCount < 1 then
        return false
    elseif tCount == 1 then
        fillInventorySlot(16)
    end

    return true
end

local function placeRail(powered)
    if turtle.detectDown() then
        turtle.digDown()
    end

    turtle.select(powered and 2 or 1)
    turtle.placeDown()
end

local function placeTorch()
    -- remove blocks
    if turtle.detectDown() then
        turtle.digDown()
    end

    turtle.down()

    if turtle.detectDown() then
        turtle.digDown()
    end

    turtle.down()

    if turtle.detectDown() then
        turtle.digDown()
    end

    turtle.down()

    -- look for torch-gound or place
    if not turtle.detectDown() then
        turtle.select(15)
        turtle.placeDown()
    end

    turtle.up()

    -- place torch
    turtle.select(16)
    turtle.placeDown()

    turtle.up()

    -- replace floor block
    turtle.select(15)
    turtle.placeDown()

    turtle.up()
end

local placePowered = false
local railIndex = 1
local torchIndex = math.floor((powerLength / 2) + 0.5)
local timeStart = os.clock()

print('railbot starting (' .. railLength .. 'x' .. powerLength .. ')')

while checkInventoryItems() do
    -- place torch if required
    if placePowered and railIndex == torchIndex then
        placeTorch()
    end

    -- place rail and move
    placeRail(placePowered)
    turtle.forward()
    railIndex = railIndex + 1

    -- switch mode
    if placePowered then
        if railIndex > poweredLength then
            railIndex = 1
            placePowered = false
        end
    else
        if railIndex > railLength then
            railIndex = 1
            placePowered = true
        end
    end
end

print('railbot: stopped, required item is out (duration:' .. durationTime(timeStart) .. ')')
