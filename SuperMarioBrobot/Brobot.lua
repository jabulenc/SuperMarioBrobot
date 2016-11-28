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

]]--