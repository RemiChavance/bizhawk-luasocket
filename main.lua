socketModule = dofile('CustomSocket.lua')

framecounter = 0

-- Connect the socket, this is blocking.
socketModule.establishConnection()

-- Main Loop.
while true do

    -- Connect the socket, this is non-blocking.
    -- coroutine.resume(socketModule.establishConnectionCoroutine)
    
    socketModule.sendMessage(framecounter)

    coroutine.resume(socketModule.readMessageCoroutine)

    emu.frameadvance()
    framecounter = framecounter + 1
end