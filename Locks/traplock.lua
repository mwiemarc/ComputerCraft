local password = 'bacon'
local openSide = 'top'
local trapSide = 'back'
local stayTime = 3

local pullEvent = os.pullEvent
os.pullEvent = os.pullEventRaw


redstone.setOutput(trapSide, true)

while true do 
	term.clear()
	term.setCursorPos(1,1)	
	
	print('Enter Password: ')	
	local input = read('*')
	
	term.clear()
	term.setCursorPos(1,1)
	
	if input == password then
		print('Password correct!')
		
		redstone.setOutput(openSide, true)
		sleep(stayTime)
		redstone.setOutput(openSide, false)		
	elseif input == 'terminate' then
		print('Termination enabled!')
		os.pullEvent = pullEvent
	else
		print('Password incorrect!')		
		
		redstone.setOutput(trapSide, false)
		sleep(stayTime)
		redstone.setOutput(trapSide, true)
	end
	
	sleep(1)
end