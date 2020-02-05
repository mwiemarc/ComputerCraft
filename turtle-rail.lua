local args = {...}

if #args ~= 2 then
    print('usage: place <length> <distance>')
    return
end

local railLength = tonumber(args[1])
local poweredLength = tonumber(args[2])

--local railLength = 27
--local poweredLength = 9

-- :: predefined item stack positions ::
-- slot 1: rail
-- slot 2: powered rail
-- slot 15: common floor block
-- slot 16: redstone torch

-- don't edit below here

local function timeDiffString(start)
    local diff = os.clock() - start

    local hrs = math.floor(diff / 3600)
    local mins = math.floor(diff / 60 - (hrs * 60))
    local secs = math.floor(diff - hrs * 3600 - mins * 60)

    return string.format('%fh%fm%fs', hrs, mins, secs)
end

local function refillSlot(slot)
    local count = turtle.getItemCount(1)

    if count < 1 then
        return false
    elseif count > 1 then
        return true
    else
        turtle.select(slot)

        for i = 1, 16 do
            if i ~= slot and turtle.compareTo(i) then
                turtle.select(i)
                turtle.transferTo(slot)
                return true
            end
        end

        return false
    end
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
local torchIndex = math.floor((poweredLength / 2) + 0.5)
local timeStart = os.clock()

print(string.format('railbot starting (%fx%f)', railLength, poweredLength))

while true do
    if not refillSlot(1) then
        print('empty slot: 1')
        return
    elseif not refillSlot(2) then
        print('empty slot: 2')
        return
    elseif not refillSlot(15) then
        print('empty slot: 15')
        return
    elseif not refillSlot(16) then
        print('empty slot: 16')
        return
    end

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

print(string.format('railbot stopped (duration: %s)', timeDiffString(timeStart)))
