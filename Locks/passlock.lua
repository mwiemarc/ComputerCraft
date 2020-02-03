local password = 'asdf'
local side = 'bottom'
local delay = 5

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
		
		
		os.pullEvent = pullEvent
		redstone.setOutput(side, true)
		
		sleep(delay)
		
		os.pullEvent = os.pullEventRaw
		redstone.setOutput(side, false)		
		
	else
		print('Password incorrect!')
	end
	
	sleep(1)
end