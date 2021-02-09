if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

--Menu Setup
function PD2QC:SetLanguage(langnumber)
    local _loc_file
    if langnumber == 1 then
        _loc_file = PD2QC._path .. "loc/en.txt"
    elseif langnumber == 2 then
        _loc_file = PD2QC._path .. "loc/es.txt"
    else
        _loc_file = PD2QC._path .. "loc/en.txt"
    end
    Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_pd2qc", function(loc)
        loc:load_localization_file(_loc_file)
    end)
end

function PD2QC:SaveSettings()
    local file = io.open(self._settings_path, "w+")
    if file then
        file:write(json.encode(self._settings))
        file:close()
    end
end

function PD2QC:LoadSettings()
    local file = io.open(self._settings_path, "r")
    if file then
        self._settings = json.decode(file:read("*all"))
        file:close()
    else
        PD2QC._settings.hud_placement = 1
        PD2QC._settings.timeout = 5
        PD2QC._settings.pausable = true
        PD2QC._paused = false
        PD2QC._settings.language = 1
    end
    PD2QC:SetLanguage(PD2QC._settings.language)
    MenuHelper:LoadFromJsonFile(PD2QC._path .. "pd2qc_menu.txt", PD2QC, PD2QC._settings)
end

Hooks:Add("MenuManagerInitialize", "InitPD2QCMenu", function(menu_manager)
    MenuCallbackHandler.pd2qc_callback_hudpos = function(self, item)
        PD2QC._settings.hud_placement = item:value()
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
        PD2QC:SaveSettings()
    end
    MenuCallbackHandler.pd2qc_callback_lang = function(self, item)
        PD2QC._settings.language = item:value()
        PD2QC:SaveSettings()
    end
    
    PD2QC:LoadSettings()
end)