if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

--Menu Setup
function PD2QC:SetLanguage(langnumber)
    local _loc_file
    if langnumber == 1 then
        PD2QC._loc_path  = PD2QC._path .. "loc/en.txt"
    elseif langnumber == 2 then
        PD2QC._loc_path  = PD2QC._path .. "loc/es.txt"
    elseif langnumber == 3 then
        PD2QC._loc_path  = PD2QC._path .. "loc/zz.txt"
    elseif langnumber == 4 then
        PD2QC._loc_path  = PD2QC._path .. "loc/cn.txt"
    elseif langnumber == 5 then
        PD2QC._loc_path = PD2QC._path .. "loc/ru.txt"
    else
        PD2QC._loc_path = PD2QC._path .. "loc/en.txt"
    end
end

function PD2QC:SaveSettings()
    local file = io.open(self._settings_path, "w+")
    if file then
        file:write(json.encode(self._settings))
        file:close()
    end
end

function PD2QC:LoadSettings()
    local file = io.open(PD2QC._settings_path, "r")
    if file then
        self._settings = json.decode(file:read("*all"))
        file:close()
    else
        PD2QC._settings.hud_placement = 1
        PD2QC._settings.timeout = 5
        PD2QC._settings.pausable = true
        PD2QC._settings.language = 1
        PD2QC._settings.persist = false
    end
    PD2QC:SetLanguage(PD2QC._settings.language)
end

Hooks:Add("MenuManagerInitialize", "InitPD2QCMenu", function(menu_manager)
    MenuCallbackHandler.pd2qc_callback_hudpos = function(self, item)
        PD2QC._settings.hud_placement = item:value()
        PD2QC:RESET()
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_persist = function(self, item)
        PD2QC._settings.persist = (item:value() == "on" and true or false)
        PD2QC:RESET()
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_timeout = function (self, item)
        PD2QC._settings.timeout = item:value()
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_voice = function (self, item)
        PD2QC._settings.voice = (item:value() == "on" and true or false)
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_pausable = function (self, item)
        PD2QC._settings.pausable = (item:value() == "on" and true or false)
        PD2QC:RESET()
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_lang = function(self, item)
        PD2QC._settings.language = item:value()
        --TODO maybe call lang update here and it can be done on the fly? needs testing
        PD2QC:SaveSettings()
    end
    
    PD2QC:LoadSettings()
    MenuHelper:LoadFromJsonFile(PD2QC._path .. "pd2qc_menu.txt", PD2QC, PD2QC._settings)
end)