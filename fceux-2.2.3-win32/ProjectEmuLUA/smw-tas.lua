local SCRIPTS_FOLDER = "src"
local ERROR_MESSAGE =  "Your emulator is not supported"

if lsnes_features and _VERSION == "Lua 5.3" then -- lsnes emulator
  local LUA_SCRIPT_FILENAME = load([==[return @@LUA_SCRIPT_FILENAME@@]==])()

  GLOBAL_SMW_TAS_PARENT_DIR = LUA_SCRIPT_FILENAME:match("(.+)[/\\][^/\\+]")

  local file = assert(loadfile(GLOBAL_SMW_TAS_PARENT_DIR .. "\\" ..
    SCRIPTS_FOLDER .. "\\smw-lsnes.lua"))
  file()

elseif bizstring then -- BizHawk emulator
  local file = assert(loadfile(SCRIPTS_FOLDER .. "\\smw-bizhawk.lua"))
  file()

elseif snes9x then -- Snes9x-rr emulator
  local file = assert(loadfile(SCRIPTS_FOLDER .. "\\smw-snes9x.lua"))
  file()

else
  print(ERROR_MESSAGE)
  if gui and gui.text then
    gui.text(0, 0, ERROR_MESSAGE)
  end

end
