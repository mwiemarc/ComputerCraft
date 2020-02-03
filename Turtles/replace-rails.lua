local powerRailLength = 9
local powerRailTorchPosition = 5
local powerRailDistance = 27

local slot = 1
local railIndex = 1
local place = false

print('starting...')

turtle.select(slot)

while turtle.getItemCount(16) > 0 do
    if place then
        if railIndex > powerRailLength then
            turtle.forward()

            railIndex = 1
            place = false
        elseif railIndex == powerRailTorchPosition then
            if turtle.detectDown() then
                turtle.digDown()
            end

            turtle.down()
            --

            if turtle.detectDown() then
                turtle.digDown()
            end

            turtle.down()
            --

            if turtle.detectDown() then
                turtle.digDown()
            end

            turtle.select(16)
            turtle.placeDown()
            --

            turtle.up()
            turtle.select(15)
            turtle.placeDown()
            turtle.up()
            --

            if turtle.getItemCount(slot) == 0 then
                slot = slot + 1
                turtle.select(slot)
            else
                turtle.select(slot)
            end

            turtle.placeDown()
            turtle.forward()

            railIndex = railIndex + 1
        else
            if turtle.getItemCount(slot) == 0 then
                slot = slot + 1
                turtle.select(slot)
            end

            if turtle.detectDown() then
                turtle.digDown()
            end

            turtle.placeDown()
            turtle.forward()

            railIndex = railIndex + 1
        end
    else
        if railIndex > powerRailDistance then
            turtle.forward()

            place = true
            railIndex = 1
        else
            turtle.forward()

            railIndex = railIndex + 1
        end
    end
end

print('ran out of torches...')
