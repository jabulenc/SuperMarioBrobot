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
successOrFail = "";
date = os.date("./testdata/%Y%m%d%H%M%S");
run = 0;
resetAt60 = 0;
count = 1;
prevInputText = "";
input = "";
sortString = "\"frame\",\"World\",\"Level\",\"Time\",\"Score\",\"X\",\"Y\",\"Vx\",\"Vy\",\"Input\"\n";
--os.execute("mkdir"..date);
file = io.open("./testdata/metadata.csv","w");
file:write(sortString);
--IMPORTANT KEEP THESE
--save = savestate.object(1);
--savestate.load(save);

-- Commented out some lines to make things easier on the data side
function genNewFile()
    --file:write("\n"..successOrFail.."\n"); We don't need success or fail. We'll just base our machine on fitness of higher X, Y, Score, Time.
    --count = 0;
    --run = run+1;
    --file:close();
    --
    --savestate.load(save); KEEP THIS
    --
    --date = os.date("./testdata/%Y%m%d%H%M%S");
    --os.execute("mkdir"..date);
    --file = io.open(date..".csv","w");
    --file:write(sortString);
end

-- Return Joypad input as string
function getInput()
    --inputs = joypad.get(1);
    if not (inputs.start or inputs.right or inputs.A) then return end; -- ignore empty inputs
    input = "";
    if (inputs.start) then 
        input = input.."START"
        return 
        end;
    --if (inputs.up) then input = input.."U" end;
    --if (inputs.down) then input = input.."D" end;
    --if (inputs.left) then input = input.."L" end;
    if (inputs.right) then input = input.."R" end;
    if (inputs.A) then input = input.."A" end;
    --if (inputs.B) then input = input.."B" end;
    --Take care of a rare but stupid case
    --if (inputs == "LRA") then
    --    inputs = "RA";
    --end;
end;

function outputtext()
    file:write("\""..count.."\","); -- Frame number
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
    --resetAt60 = resetAt60 +1;
    prevInputText = input; -- Store prior input
    inputs = joypad.get(1);
    if (inputs.start or inputs.right or inputs.A) then
        getInput(); -- Grab current input before we do ANYTHING
    
    --if (input ~= prevInputText or (resetAt60 % 15 == 0)) then -- ONLY record data if it's different than the previous input
        outputtext();
        gui.savescreenshotas("./testdata/"..count..".png");  
        count = count + 1;
    --end -- End recording block
    end;
    emu.frameadvance(); -- Always always always advance frame 
    --if (resetAt60 == 59) then resetAt60 = 0 end
end

--[[ Deprecated code but useful for later
Determine current Mario-State
if (memory.readbyte(0x000E) == 0 or memory.readbyte(0x000E) == 11 or memory.readbyte(0x000E) == 4) then
            if (memory.readbyte(0x000E) == 0 or memory.readbyte(0x000E) == 11) then
                successOrFail = 0;
            else
                successOrFail = 1;
            end
            --genNewFile();
        end

]]