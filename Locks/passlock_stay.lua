local password = 'asdf'
local side = 'bottom'

local pullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw

while true do 
	term.clear()
	term.setCursorPos(1,1)	
	
	print('Enter Password: ')	
	local input = read('*')
	
	term.clear()
	term.setCursorPos(1,1)
	
	if input == password then
		print('Password correct!')
		print('Press Return to close door.')
		
		os.pullEvent = pullEvent
		
		redstone.setOutput(side, true)
		
		sleep(1)
		
		-- wait for enter
		while true do
			local sEvent, param = os.pullEvent("key")

			if sEvent == "key" then
				if param == 28 then
					print('Closing...')
					break
				end
			end
		end
		
		redstone.setOutput(side, false)		
		
		os.pullEvent = os.pullEventRaw
	else
		print('Password incorrect!')
	end
	
	sleep(1)
end