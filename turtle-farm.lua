local width = 4
local length = 4
local startLeft = true
local dropItems = true

--
-- dont edit below here
--
local timeStart = os.clock()
local slot = 1

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

-- check for initial items to place
if turtle.getItemCount(slot) == 0 then
	print('error: nothing to place in slot 1!')
	return
end

turtle.select(slot) -- select first slot

print(string.format('farmbot starting (' .. length .. 'x' .. width .. ')'))

-- farm loop
for y = 1, width do
	for x = 1, length do
		local newSlot = 0

		-- find same items to place
		if turtle.getItemCount(slot) == 1 then
			newSlot = -1

			for i = 1, 16 do
				if i ~= slot and turtle.compareTo(i) then -- find same item
					newSlot = i
					break
				end
			end
		end

		-- dig and place
		turtle.digDown()
		turtle.digDown()
		turtle.placeDown()

		-- select new inventory slot
		if newSlot > 0 then
			slot = newSlot
			turtle.select(slot)
		elseif newSlot < 0 then
			print('error: nothing to place left in inventory!')
			return
		end

		-- go forward if not on edge
		if x ~= length then
			turtle.forward()
		end
	end

	-- move to next row
	if y ~= width then
		if (y % 2) == 0 then
			if startLeft then
				turtle.turnLeft()
				turtle.forward()
				turtle.turnLeft()
			else
				turtle.turnRight()
				turtle.forward()
				turtle.turnRight()
			end
		else
			if startLeft then
				turtle.turnRight()
				turtle.forward()
				turtle.turnRight()
			else
				turtle.turnLeft()
				turtle.forward()
				turtle.turnLeft()
			end
		end
	end
end

-- move back if ended on uneven row
if (width % 2) ~= 0 then
	-- move back
	for i = 1, (length - 1) do
		turtle.back()
	end

	-- turn
	if startLeft then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end
else
	-- turn
	if startLeft then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end
end

-- move cells down
for i = 1, (width - 1) do
	turtle.forward()
end

if dropItems then -- drop items
	if startLeft then
		turtle.turnLeft()
	else
		turtle.turnRight()
	end

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

	-- turn into start pos
	if startLeft then
		turtle.turnRight()
		turtle.turnRight()
	else
		turtle.turnLeft()
		turtle.turnLeft()
	end
else
	-- turn into start pos
	if startLeft then
		turtle.turnRight()
	else
		turtle.turnLeft()
	end
end

print(string.format('farmbot finished (' .. durationString(timeStart) .. ')'))
