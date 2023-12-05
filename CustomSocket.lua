-- WORKS PERFECTLY SEND AND RECEIVE !

-- load namespace
socket = require('socket')
print("luasocket is loaded!")
print()

-- script global variable
local frameCount = 0
local isConnected = false
local conn = nil

-- script shutdown hook
event.onexit( function()
	if isConnected then
		print("Closing connection")
		conn:shutdown()
		conn:close()
	end
end)


function disconnect()
	conn:shutdown()
	conn:close()
	isConnected = false
	conn = nil
end

-- bind tcp socket to the server
local establishConnection = coroutine.create( function()
	while 1 do
		if not isConnected then
			if (conn == nil) then
				conn = socket:tcp()
				conn:settimeout(0) -- non-blocking
			end
			print("Attempting to connect...")
			local stat, err = conn:connect("127.0.0.1", 12345, 1)
			if (stat == 1) then
				print("Connection established: " .. stat)
				isConnected = true
			elseif (err == 'already connected') then
				print("Connection already established: " .. err)
				isConnected = true;
			else
				print("Error creating connection: " .. err)
			end
		else 
			print("Already connected")
		end
		coroutine.yield()
	end
end);

-- coroutine for looking for server messages
local readMessage = coroutine.create( function()
	while 1 do
		if isConnected then
			resp, err = conn:receive('*l')
			if (resp) then
				print("Received: " .. resp)
			else
				-- print("Error: " .. err)
			end
		end
		coroutine.yield()
	end
end)

print("Starting main loop")
while true do
	if (math.fmod(frameCount, 60) == 0) then
		-- print("Now")
	end

	if (not isConnected) and (math.fmod(frameCount, 60) == 0) then
		coroutine.resume(establishConnection)
	end

	if isConnected then
		coroutine.resume(readMessage)
	end
		
	if isConnected then --and (math.fmod(frameCount, 10) == 0) then
		conn:send(frameCount)
        -- console.log('sending message!')
	end

	emu.frameadvance()
    frameCount = frameCount + 1
end