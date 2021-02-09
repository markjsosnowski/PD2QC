--Setup
if not _G.PD2QC then
    _G.PD2QC = {}
    dofile(ModPath .. "lua/pd2qc_hud.lua")
    dofile(ModPath .. "lua/pd2qc_menu.lua")
    PD2QC.VERSION = "1.1"
    PD2QC._path = ModPath
    PD2QC._settings_path = SavePath .. "pd2qc_settings.txt"
    PD2QC._paused = false
    PD2QC._settings = {}
    PD2QC:LoadSettings()
end

if not _G.DelayedCallsFix then
    dofile(ModPath .. "lua/delayed_calls.lua")
end

--If you want to change the chat message,
--do it in the localization file, not here.
PD2QC.CHATS = {
    LEFT={
        LEFT="pd2qc_left_left",
        UP="pd2qc_left_up",
        RIGHT="pd2qc_left_right",
        DOWN="pd2qc_left_down"
    },
    UP={
        LEFT="You get it.",
        UP="I got it.",
        RIGHT="I found equipment.",
        DOWN="Take hostages."
    },
    RIGHT={
        LEFT="Out of Ammunition!",
        UP="Need Doctor Bag!",
        RIGHT="Help me!",
        DOWN="Sniper here!"
    },
    DOWN={
        LEFT="Come here.",
        UP="Stay there.",
        RIGHT="Let's go.",
        DOWN="Take cover."
    }
}

PD2QC.CATEGORY = {
    LEFT = "Stealth",
    UP = "General",
    RIGHT = "Loud",
    DOWN = "Orders"
}

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
    if(PD2QC._settings.persist) then
        PD2QC:ShowHintPanel(PD2QC.CATEGORY)
    end
end

--For Testing, Not Used. Prints a system message instead of a HUD element of the choices.
function PD2QC:BETA_HINTPOPUP(chat_table)
    local _hint_message = "[PD2QC]\nUP:" .. chat_table["UP"] .. "\nLEFT:" .. chat_table["LEFT"] .. "\nRIGHT:" .. chat_table["RIGHT"] .. "\nDOWN:" .. chat_table["DOWN"]
    managers.chat:feed_system_message(ChatManager.GAME, _hint_message)
end