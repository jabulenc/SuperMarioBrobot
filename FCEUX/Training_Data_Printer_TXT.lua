-- Training Data Producer for SMBRobot
-- 10/23/2016
-- Key:
-- F: Count/Frame
-- W: World
-- L: Level
-- T: Time
-- S: Score
-- X: X Coordinate
-- Y: Y Coordinate
-- Vx: Velocity X
-- Vy: Velocity Y
-- I: Input - will only output LRUPBA depending input
emu.loadrom(emu.getdir()..'/Super Mario Bros. (Japan, USA).zip');
successOrFail = "";
date = os.date("./testdata/%Y%m%d%H%M%S");
run = 0;
count = 0;
input = {};
sortString = "\"frame\",\"World\",\"Level\",\"Time\",\"Score\",\"X\",\"Y\",\"Vx\",\"Vy\",\"Input\"\n";
os.execute("mkdir"..date);
file = io.open(date..".csv","w");
file:write(sortString);
save = savestate.object(1);
savestate.load(save);

function genNewFile()
    --file:write("\n"..successOrFail.."\n"); We don't need success or fail. We'll just base our machine on fitness of higher X, Y, Score, Time.
    count = 0;
    run = run+1;
    --file:close();
    savestate.load(save);
    --date = os.date("./testdata/%Y%m%d%H%M%S");
    --os.execute("mkdir"..date);
    --file = io.open(date..".csv","w");
    --file:write(sortString);
end

-- Return Joypad input as string
function getInput()
    input = "";
    inputs = joypad.get(1);
    if (inputs.up) then input = input.."U" end;
    if (inputs.down) then input = input.."D" end;
    if (inputs.left) then input = input.."L" end;
    if (inputs.right) then input = input.."R" end;
    if (inputs.A) then input = input.."A" end;
    if (inputs.B) then input = input.."B" end;
end;

function outputtext()
    getInput();
    file:write("\""..run.."_"..count.."\","); -- Frame number
    file:write("\""..memory.readbyte(0x075F).."\","); --World
    file:write("\""..memory.readbyte(0x0760).."\","); --Level
    file:write("\""..memory.readbyte(0x07F8)..memory.readbyte(0x07F9)..memory.readbyte(0x07FA).."\","); --Time
    file:write("\""..memory.readbyte(0x07d7)..memory.readbyte(0x07d8)..memory.readbyte(0x07d9)..memory.readbyte(0x07da)..memory.readbyte(0x07db)..memory.readbyte(0x07dc).."0\","); --Score
    file:write("\""..memory.readbyte(0x006D).."."..memory.readbyte(0x0086).."\","); --X
    file:write("\""..memory.readbyte(0x00B5).."."..memory.readbyte(0x00CE).."\","); --Y
    file:write("\""..memory.readbyte(0x0057).."\","); --Vx
    file:write("\""..memory.readbyte(0x009F).."\",");--Vy
    file:write("\""..input.."\""); --Input
    file:write("\n"); --Newline
end
-- 4, 0, 11 (0C) are Non-play
-- 8 is normal
while true do
    outputtext();
    gui.savescreenshotas(date.."/"..run.."_"..count..".png");
    if (memory.readbyte(0x000E) == 0 or memory.readbyte(0x000E) == 11 or memory.readbyte(0x000E) == 4) then
        if (memory.readbyte(0x000E) == 0 or memory.readbyte(0x000E) == 11) then
            successOrFail = 0;
        else
            successOrFail = 1;
        end
        genNewFile();
    end
    count = count + 1;
    emu.frameadvance();     
end