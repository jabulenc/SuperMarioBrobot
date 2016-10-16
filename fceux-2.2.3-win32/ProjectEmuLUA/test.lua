-- ====================================== --
--          Created by Anthony J.         --
--               2015-06-29               --   
-- ====================================== --
-- !!!! Unfinished and buggy version !!!! --
-- ====================================== --
-- DEFINITIONS:
-- -> setFrameCount(int) = How much frames will be predicted at a time
-- -> setPredictonFrameCount(int) = How much frames will be predicted after the previous frames (this ones do not execute)
-- -> defineVariable(int, string, int) = Variable that modifies progression score
-- -> defineControl(int, int, int, int) = Defines controls that can be active at the same time in one frame (from 0 to 4 per each function)
-- NOTICE:
-- Holding the G key in Think Mode (when the screen is frozen) will replay the bot's actions
-- To optimize the bot for a different game, simply edit initialize and change the game variable
-- To make the bot work better, instead of just score variables, insert the screen/player X and Y coordinates as variables
-- To use this you need the special version of SNES9X with Lua code support, it can be found here: https://code.google.com/p/snes9x-rr/
-- RIGHTS/LICENSE:
-- No license. You are free to use this however you want (personal, commercial, etc...) and there is no need to give me credit
-- This was uploaded just as a backup, so if I ever decide to complete the project I could find it easier (I doubt so)

Game = "Megaman X"

function initialize(String)
	if (Game == "Megaman X") then
		-- Settings
		setFrameCount(10)
		setPredictionFrameCount(15)
		-- Variables
		defineVariable(0x7E0BCF, "increase", 10240) -- Health
		defineVariable(0x7E0BCB, "increase", 1024) -- PlayerHighX
		defineVariable(0x7E0BCA, "increase", 4) -- PlayerLowX
		defineVariable(0x7E0BB1, "decrease", 256) -- PlayerHighY
		defineVariable(0x7E0BB0, "decrease", 1) -- PlayerLowY
		-- Controls
		defineControl("right", "B")
		defineControl("right", "Y")
		defineControl("right")
		defineControl("Y")
		defineControl("B")
		defineControl("left", "B")
		defineControl("left", "Y")
	end
end

Variables = {}
VariableID = 0
Controls = {}
ControlID = 0
ControlTable = joypad.get(1)

for k, v in pairs(ControlTable) do
	ControlTable[k] = false
end

function setFrameCount(Value)
	FrameCount = Value
end

function copytable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copytable(orig_key)] = copytable(orig_value) -- possible stack overflow
        end
        setmetatable(copy, copytable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function setPredictionFrameCount(Value)
	PredictionFrameCount = Value
end

function defineVariable(Address, Type, Modifier)
	VariableID = VariableID + 1
	local Table = {}
	Table[1] = Address
	if (Type == "increase") then
		Table[2] = 1
	elseif (Type == "decrease") then
		Table[2] = -1
	end
	Table[3] = Modifier
	Variables[VariableID] = table.copytable(Table)
end

function defineControl(Key1, Key2, Key3, Key4)
	ControlID = ControlID + 1
	local Table = {}
	local ID = 0
	if (Key1) then
		ID = ID + 1
		Table[ID] = Key1
	end
	if (Key2) then
		ID = ID + 1
		Table[ID] = Key2
	end
	if (Key3) then
		ID = ID + 1
		Table[ID] = Key3
	end
	if (Key4) then
		ID = ID + 1
		Table[ID] = Key4
	end
	Controls[ControlID] = copytable(Table)
end

function getScore()
	local Score = 0
	for k, v in pairs(Variables) do
		Score = Score + (memory.readbyte(v[1]) * v[2] * v[3])
	end
	return Score
end

function getEmptyControlTable()
	return copytable(ControlTable)
end

InitSave = savestate.create()
TempSave = savestate.create()
TempSave2 = savestate.create()
FrameCount = -1
PredictionFrameCount = -1
MovementLibrary = {}
MovementID = 0

function getNextStep(PreviousScore)
	local OptimalTable = getEmptyControlTable()
	local OptimalScore = PreviousScore
	local ReturnScore = PreviousScore
	for k, v in pairs(Controls) do
		local TempCtrlTable1 = getEmptyControlTable()
		if (v[1]) then
			TempCtrlTable1[v[1]] = true
		end
		if (v[2]) then
			TempCtrlTable1[v[2]] = true
		end
		if (v[3]) then
			TempCtrlTable1[v[3]] = true
		end
		for i = 0, FrameCount do
			joypad.set(1, TempCtrlTable1)
			emu.frameadvance()
		end
		local TempCtrlScore1 = getScore()
		local TempCtrlTable2 = getEmptyControlTable()
		local TempTable = Controls[1]
		savestate.save(TempSave2)
		if (TempTable[1]) then
			TempCtrlTable2[TempTable[1]] = true
		end
		if (TempTable[2]) then
			TempCtrlTable2[TempTable[2]] = true
		end
		if (TempTable[3]) then
			TempCtrlTable2[TempTable[3]] = true
		end
		for i = 0, PredictionFrameCount do
			joypad.set(1, TempCtrlTable2)
			emu.frameadvance()
		end
		local TempCtrlScore2 = getScore()
		savestate.load(TempSave2)
		for i = 0, PredictionFrameCount do
			joypad.set(1, TempCtrlTable1)
			emu.frameadvance()
		end
		local TempCtrlScore3 = getScore()
		if (TempCtrlScore2 > OptimalScore) or (TempCtrlScore3 > OptimalScore) then
			OptimalTable = copytable(TempCtrlTable1)
			if (TempCtrlScore3 > TempCtrlScore2) then
				OptimalScore = TempCtrlScore3
			else
				OptimalScore = TempCtrlScore2
			end
			ReturnScore = TempCtrlScore1
		end
		savestate.load(TempSave)
	end
	return OptimalTable, ReturnScore
end

function getControls(CtrlTable)
	local CtrlString = ""
	for k, v in pairs(CtrlTable) do
		if (v) then
			CtrlString = CtrlString .. " " .. k
		end
	end
	return CtrlString
end

function thinkMode()
	local thinkPhase = true
	MovementLibrary = {}
	MovementID = 0
	emu.speedmode("maximum")
	savestate.save(InitSave)
	while (thinkPhase) do
		savestate.save(TempSave)
		local CurrentScore = getScore()
		local OptimalTable, NextScore = getNextStep(CurrentScore)
		MovementID = MovementID + 1
		MovementLibrary[MovementID] = copytable(OptimalTable)
		local CurrentValue = getControls(OptimalTable)
		if (CurrentValue == "") then
			print("-> No next control!")
		else
			print("-> Next control: " .. CurrentValue)
		end
		print("Score: " .. tostring(NextScore) .. " (" .. tostring(NextScore - CurrentScore) .. ")")
		for i = 0, FrameCount do
			joypad.set(1, OptimalTable)
			emu.frameadvance()
		end
		local Input = input.get()
		if (Input["G"]) then
			thinkPhase = false
		end
	end
	replayMode()
end

function replayMode()
	local replayPhase = true
	emu.speedmode("normal")
	savestate.load(InitSave)
	for k, v in pairs(MovementLibrary) do
		if (replayPhase) then
			for i = 0, FrameCount do
				joypad.set(1, v)
				emu.frameadvance()
			end
		end
	end
	thinkMode()
end

initialize(Game)
thinkMode()