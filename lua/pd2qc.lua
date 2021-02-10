--Setup
if not _G.PD2QC then
    _G.PD2QC = {}
    dofile(ModPath .. "lua/pd2qc_hud.lua")
    dofile(ModPath .. "lua/pd2qc_menu.lua")
    PD2QC.VERSION = "1.1.1"
    PD2QC._path = ModPath
    PD2QC._settings_path = SavePath .. "pd2qc_settings.txt"
    PD2QC._paused = false
    PD2QC._settings = {}
    PD2QC:LoadSettings()
    PD2QC:SetLanguage(PD2QC._settings.language)
end

if not _G.DelayedCallsFix then
    dofile(ModPath .. "lua/delayed_calls.lua")
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_pd2qc", function(loc)
    loc:load_localization_file(PD2QC._loc_path)
    --IF YOU'RE LOOKING TO CUSTOMIZE CHAT LINES
    --YOU SHOULD DO IT IN THE LOCALIZATION FILES
    PD2QC.CHATS = {
        LEFT={
            LEFT=   loc:text("pd2qc_left_left"),
            UP=     loc:text("pd2qc_left_up"),
            RIGHT=  loc:text("pd2qc_left_right"),
            DOWN=   loc:text("pd2qc_left_down")
        },
        UP={
            LEFT=   loc:text("pd2qc_up_left"),
            UP=     loc:text("pd2qc_up_up"),
            RIGHT=  loc:text("pd2qc_up_right"),
            DOWN=   loc:text("pd2qc_up_down")
        },
        RIGHT={
            LEFT=   loc:text("pd2qc_right_left"),
            UP=     loc:text("pd2qc_right_up"),
            RIGHT=  loc:text("pd2qc_right_right"),
            DOWN=   loc:text("pd2qc_right_down")
        },
        DOWN={
            LEFT=   loc:text("pd2qc_down_left"),
            UP=     loc:text("pd2qc_down_up"),
            RIGHT=  loc:text("pd2qc_down_right"),
            DOWN=   loc:text("pd2qc_down_down")
        }
    }
    PD2QC.CATEGORY = {
        LEFT=       loc:text("pd2qc_left_category"),
        UP =        loc:text("pd2qc_up_category"),
        RIGHT =     loc:text("pd2qc_right_category"),
        DOWN =      loc:text("pd2qc_down_category")
    }
end)

PD2QC.VOICE ={} --TODO assign each command a relevant voice line

--Main Script
PD2QC.PREV = nil

--TODO if persistant_menu, show it at mission start

function PD2QC:SELECT(direction)
    if PD2QC.PREV then
        managers.chat:send_message(1,'?',PD2QC.CHATS[PD2QC.PREV][direction], Color.green)
        PD2QC:RESET()
    else
        PD2QC.PREV = direction
        PD2QC:RemoveHintPanel()
        PD2QC:ShowHintPanel(PD2QC.CHATS[direction])
        DelayedCallsFix:Add("PD2QCtimeout", PD2QC._settings.timeout, function()
            PD2QC:RESET()
        end)
    end
end

function PD2QC:RESET()
    PD2QC.PREV = nil
    PD2QC:RemoveHintPanel()
    DelayedCallsFix:Remove("PD2QCtimeout")
    if(PD2QC._settings.persist and not (PD2QC._settings.pausable and PD2QC._paused)) then
        PD2QC:ShowHintPanel(PD2QC.CATEGORY)
    end
end