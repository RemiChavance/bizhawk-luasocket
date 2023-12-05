-- load namespace
socket = require('socket')

local isConnected = false
local conn = nil

-- Script shutdown hook.
event.onexit(function()
	if isConnected then
		print("Closing connection")
		conn:shutdown()
		conn:close()
	end
end)

-- Disconnect the socket.
function disconnect()
	conn:shutdown()
	conn:close()
	isConnected = false
	conn = nil
end


-- Coroutine for establish a connection on the socket,
-- this will not block the main loop.
local establishConnectionCoroutine = coroutine.create(function()
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
			-- print("Already connected")
		end
		coroutine.yield()
	end
end);


-- Function for establish a connection on the socket,
-- this function will block the main loop.
function establishConnection()
	print("Attempting to connect...")
	while not isConnected do
		if (conn == nil) then
			conn = socket:tcp()
			conn:settimeout(0) -- non-blocking
		end
		local stat, err = conn:connect("127.0.0.1", 12345, 1)
		if (stat == 1) then
			print("Connection established: " .. stat)
			isConnected = true
		elseif (err == 'already connected') then
			-- print("Connection already established: " .. err)
			isConnected = true;
		else
			-- print("Error creating connection: " .. err)
		end
	end
end

-- Coroutine for looking for server messages.
local readMessageCoroutine = coroutine.create(function()
	while 1 do
		if isConnected then
			resp, err = conn:receive('*l') -- all messages have to end with '\n'
			if (resp) then
				print("Received: " .. resp)
			else
				-- print("Error: " .. err)
			end
		end
		coroutine.yield()
	end
end)

-- Send m through the socket.
function sendMessage(m)
	if isConnected then
		conn:send(m)
	else
		print('Not connected')
	end
end


return {
	establishConnectionCoroutine = establishConnectionCoroutine,
	establishConnection = establishConnection,
	readMessageCoroutine = readMessageCoroutine,
	sendMessage = sendMessage
}