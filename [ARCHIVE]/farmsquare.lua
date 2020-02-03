local farmWidth = 4
local farmLength = 4
local farmStartLeft = true

--
-- dont edit below here
--
local function farmSquare(width, length, startLeft)
	local slot = 1
	turtle.select(slot) -- select first slot
	
	-- check for initial items to place
	if turtle.getItemCount(slot) == 0 then
		print('error: nothing to place in slot 1!')
		return
	end
	
	print('start farming: ' .. length .. 'x' .. width)

	for y = 1, width do
		for x = 1, length do
			-- dig and place
			turtle.digDown()
			turtle.digDown()
			turtle.placeDown()

			-- select next slot if current is empty
			if turtle.getItemCount(slot) == 0 then
				slot = slot + 1
				turtle.select(slot)
			end

			-- go forward if not on edge
			if x ~= length then
				turtle.forward()
			end
		end

		if y ~= width then			
			-- move to next row
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
		else
			-- move back if ended on uneven row
			if (y % 2) ~= 0 then
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
			
			-- turn into start pos
			if startLeft then			
				turtle.turnRight()
			else					
				turtle.turnLeft()
			end
		end
	end
	
	print('finished farming')
end

farmSquare(farmWidth, farmLength, farmStartLeft)
