# Bizhawk LuaSocket

Here's an implementation of Bizhawk that can run Lua script using LuaSocket.
Only tested with Windows 10 Pro Version 22H2, Python 3.12.0, Bizhawk 2.9.1

## How to use it

- Download and unzip your Bizhawk emulator in ./bizhawk directory.
- Launch EmuHawk.exe
- Go to Tools > Lua Console
- In Lua Console, go to Script > Open Script...
- Open Main.lua file at the root of this project
- In a terminal run python Main.py

Make sure to have 12345 port available on localhost.
You can configure address and port at the top of Main.py and CustomSocket.lua.

Every frame, Lua will send a framecounter to python via socket.
Every received framcounter, Python will response to Lua with the framecounter it just received.
Python and Lua will both displaying the framecounter.

## What are the changing ?

Some files are simply added in bizhawk's root directory.
Theses files implement LuaSocket and Bizhawk can use them.
See ./bizhawk/README.md.

## Sources

- [Stackoverflow post](https://stackoverflow.com/questions/33428382/add-luasocket-to-program-bizhawk-shipped-with-own-lua-environment)
- [Antogerva's Github](https://github.com/antogerva/emuHostUDP)
- [Gikkman's Github](https://github.com/Gikkman/bizhawk-communication)
