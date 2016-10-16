local table = {}
local framelimit = 120
_G.frameCount = 0
_G.frameDisplay = 0
_G.nextInput = {}
_G.Score = 0

doInput = function() 
    local i = 30
    while i > 0 do
        joypad.set(1, _G.nextInput)
        emu.frameadvance()
        i = i - 1
    end
end

onDeath = function()
    print("You died")
    savestate.load(_G.state)
    _G.frameCount = math.floor(math.random(_G.frameCount))
    _G.frameDisplay = 0
    _G.Score = 0
end

_G.state = savestate.create(1)
savestate.save(_G.state)


while true do
    _G.randomthought = math.random(0,3);
    print("I'm debug...".._G.randomthought)
    emu.message(memory.readbyte(0x006D))
   -- if memory.readbyte(0x000E) == 0x0B or memory.readbyte(0x000E) == 0x06 then
   if memory.readbyte(0x000E) ~= 0x08 then  
        onDeath()
    end
    table=joypad.get(1)
    _G.frameCount = _G.frameCount + 1
    _G.frameDisplay = _G.frameDisplay + 1
    dofile("IWillReadYourImage.lua")
    doInput()          
end

--[[

Ideas for later
- End of level is flagpole event (ignores flag score though?!)
Needs to be X/Y coordinate independent - or does it? Output X value to screen
Time vs Score?
How to examine input data?
    Idea- frame for frame, score delta + frame number + prev input
    I2 - Upon death, send score to get value, pass that with parsed inputs to learning
        Based on previous, whatever the order of inputs is, give slight boosts whenver X was made bigger for each input (in order)
        ex-  Right Right Right A A A Right Right (Dead) X = 5
             Right Right Right Right Left Right Right Right A (Dead) X = 9
        FRAMES 1 2 3 4 5 6 7 8 9
        Right  7 7 7 4 0 4 7 7 0
        A      0 0 0 2 2 2 0 0 4
        Left   0 0 0 0 4 0 0 0 0

        Wins will receive the full score for their X value- deaths only half.

        Technical PRoposal-
            Technical details]
            Eval techniques
            How to divide the work
            ALgorithm == process


        Learning Componenent returns array of inputs in order of when they should be called
]]--