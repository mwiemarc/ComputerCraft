local args = {...}

if #args ~= 3 then
    print('usage: place <side> <count> <distance>')
    return
end

local pSide = tostring(args[1])
local pCount = tonumber(args[2])
local pDist = tonumber(args[3])

local timeDiffString = function(start)
    local diff = os.clock() - start

    local hrs = math.floor(diff / 3600)
    local mins = math.floor(diff / 60 - (hrs * 60))
    local secs = math.floor(diff - hrs * 3600 - mins * 60)

    return string.format('%dh%dm%ds', math.floor(hrs + 0.5), math.floor(mins + 0.5), math.floor(secs + 0.5))
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

local function placeOnSide(side)
    turtle.select(1)

    if side == 'top' then
        while turtle.detectUp() do
            turtle.digUp()

            sleep(0.35)
        end

        turtle.placeUp()
    elseif side == 'bottom' then
        if turtle.detectBottom() then
            turtle.digBottom()

            sleep(0.35)
        end

        turtle.placeBottom()
    elseif side == 'left' then
        turtle.turnLeft()

        while turtle.detect() do
            turtle.dig()

            sleep(0.35)
        end

        turtle.place()
        turtle.turnRight()
    elseif side == 'right' then
        turtle.turnRight()

        while turtle.detect() do
            turtle.dig()

            sleep(0.25)
        end

        turtle.place()
        turtle.turnLeft()
    else
        return false
    end

    return true
end

local place = true
local index = 1
local timeStart = os.clock()

print(string.format('placebot starting (%f to %f, side: %s)', pCount, pDist, pSide))

while true do
    if not refillSlot(1) then
        print('empty slot: 1')
        return
    end

    if place then
        if not placeOnSide(pSide) then
            print(string.format('unsupported side: %s (supported sides: top, bottom, left, right', side))
            return
        end
    end

    turtle.forward()
    index = index + 1

    if place then
        if index > pCount then
            place = false
            index = 1
        end
    else
        if index > pDist then
            place = true
            index = 1
        end
    end
end

print(string.format('placebot stopped (duration: %s)', timeDiffString(timeStart)))
