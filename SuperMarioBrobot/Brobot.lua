--[[
Brainstorming:
Maybe have all things fire off with a script: http://www.fceux.com/web/help/fceux.html?CommandLineOptions.html
First, need to load existing network. MVP: use hard coded name
    Make sure to repopulate grad whatevers
Define functions; will probably reuse general concept from data creator
Evaluate every 15th frame; 1/4 of all frames
    Input will last for 1/4 frames.
Evaluate by converting logarithmic probability to decimal probability
Maybe smooth input? Ask Pallabi about weights again
    Instead of taking just the heighest predicition, check if the last frame's input is close for the current frame; if so, just use the same input (20%? Less?)
Send the video through the network prior to the frameadvance.
EVERY 30 FRAMES, ONE FRAME OF EMPTY INPUT
]]--
-- Includes
require 'nn'
require 'torch'
require 'image'

-- Variables
classes = {'RA', 'R', 'A', 'START'}
screen = torch.FloatTensor(1, 3, 256, 224); -- The frame as a tensor
frameCt = 0;

-- Necessary Functions

function craftWeight(module)
   if module.weight then module.gradWeight = module.weight:clone() end
   if module.bias   then module.gradBias   = module.bias  :clone() end
   module.gradInput  = torch.Tensor()
end

function repopulateGrad(network)
   craftWeight(network)
   if network.modules then
      for _,a in ipairs(network.modules) do
         repopulateGrad(a)
      end
   end
end

function IndexOfMax(t)
    local key, max = 1, t[1]
    for k, v in ipairs(t) do
        if t[k] > max then
            key, max = k, v
        end
    end
    return key;
end;

function GetFrameAndSetScreen()
    gui.savescreenshotas("./cur.png");
    screen = image.load("./cur.png",3,'byte');
end;

function ProcessFrameAndGetInput(md)
--print(screen:size())
	--gui.text(50,50,screen:size());
    --predInput = md:forward(screen);
--print (predInput);
    --SetInput(classes[IndexOfMax(predInput)]);
end;

function SetInput(class)
    if class == "START" then
    joypad.set(1, {start = true, right = false, A = false});
    end;
    if class == "RA" then
    joypad.set(1, {start = false, right = true, A = true});
    end;
    if class == "A" then
    joypad.set(1, {start = false, right = false, A = true});
    end;
    if class == "R" then
    joypad.set(1, {start = false, right = true, A = false});
    end;
end;

function ClearInput()
    joypad.set(1, {start = false, right = false, A = false});
	gui.text(0,0,"NONE");
end;

-- Step 1 : Load the network
model = torch.load("results/model.net");
repopulateGrad(model);
res = {0,0,0,0};
-- Step 2 : The Runtime Loop

while true do
    frameCt = frameCt + 1;
    gui.text(50,50,frameCt);
	ay = 1.01;
gui.text(50,60,classes[IndexOfMax(res)]);
	gui.text(50,70, res[1]);
gui.text(50,80, res[2]);
gui.text(50,90, res[3]);
gui.text(50,100, res[4]);
    if not (frameCt == 30) then
        if (frameCt % 15 == 0) then
            GetFrameAndSetScreen();
	    res = dofile('process.lua');
	SetInput(classes[IndexOfMax(res)]);
        end;
    else
    end;
    emu.frameadvance();
    if frameCt == 60 then frameCt = 0 end;
end;

