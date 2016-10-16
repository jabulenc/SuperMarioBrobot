print("I'm thinking...'")
if _G.frameCount%2 == 0 then
    _G.nextInput = {right=randomright, A=randomjump}
else
    _G.nextInput = {right=randomright}
end

randomright = function() return math.ceil(math.random(0,1)) end
randomjump = function() return math.floor(math.random(0,1)) end

print("I'm thinking...'")
if _G.frameCount%2 == 0 then
    _G.nextInput = {right=randomright, A=randomjump}
else
    _G.nextInput = {right=randomright}
end