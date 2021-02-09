if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

--Menu Setup

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
    end
end

Hooks:Add("MenuManagerInitialize", "InitPD2QCMenu", function(menu_manager)
    MenuCallbackHandler.pd2qc_callback_hudpos = function(self, item)
        PD2QC._settings.hud_placement = item:value()
        log("[PD2QC] hud placement set to " .. item:value())
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
        PD2QC._settings.voice = item:value()
        PD2QC:SaveSettings()
    end

    PD2QC:LoadSettings()
    MenuHelper:LoadFromJsonFile(PD2QC._path .. "pd2qc_menu.txt", PD2QC, PD2QC._settings)

end)

--[[Hides the HUD when the pause menu (ESC) is opened
Hooks:PreHook(MenuPauseRenderer, "open", "pd2qc_pause_open", function()
    DelayedCallsFix:Remove("PD2QCtimeout")
    PD2QC._paused = true
    PD2QC:RESET()
end)

Hooks:PreHook(MenuPauseRenderer, "close", "pd2qc_pause_close", function()
    PD2QC._paused = false
end)
]]
