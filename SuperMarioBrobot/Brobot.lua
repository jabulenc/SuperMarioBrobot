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
model;
predInput = {};
screen = torch.Tensor(1, 3, 256, 224); -- The frame as a tensor

-- Necessary Functions
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
    screen[1] = image.load"./cur.png",3,'byte')
end;

function ProcessFrameAndGetInput()
    predInput = model:forward(screen);
    SetInput(classes[IndexOfMax(predInput)]);
end;

function SetInput(class)
    if class == "START" then
    joypad.set(1, {start = true, right = false, A = false});
    end;
    if class == "RA" then
    joypad.set(1, {start = false, right = true, A = true});
    end;
    if class == "A" then
    joypad.set(1, {start = false, right = true, A = false});
    end;
    if class == "R" then
    joypad.set(1, {start = false, right = false, A = true});
    end;
end;

function ClearInput()
    joypad.set(1, {start = false, right = false, A = false});
end;

-- Step 1 : Load the network
model = torch.load(opt.load);
repopulateGrad(model);

