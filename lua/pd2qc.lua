--Setup
if not _G.PD2QC then
    _G.PD2QC = {}
    dofile(ModPath .. "lua/pd2qc_HUDmanager.lua")
    dofile(ModPath .. "lua/pd2qc_menumanager.lua")
    PD2QC.VERSION = "1.1"
    PD2QC._path = ModPath
    PD2QC._settings_path = SavePath .. "pd2qc_settings.txt"
    PD2QC._settings = {}
    PD2QC._paused = false
end

if not _G.DelayedCallsFix then
    dofile(ModPath .. "lua/delayed_calls.lua")
end

--IF YOU DON'T KNOW WHAT YOU ARE DOING
--ONLY CHANGE THINGS INSIDE THIS BOX
--───────────────────────────────────────────────────────────┐
--If you wish to change the specific chat messages,
--do so in this table and only in this table.
--Everything else will be changed automatically.
PD2QC.CHATS = {
    LEFT={
        LEFT="Answer this pager.",
        UP="Use your ECM now!!",
        RIGHT="Bag this body.",
        DOWN="Watch out!"
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

--When the persistant_menu setting is true, a hint menu
--showing these catagories will always been on the HUD
PD2QC.CATEGORY = {
    LEFT = "Stealth",
    UP = "General",
    RIGHT = "Loud",
    DOWN = "Orders"
}
--───────────────────────────────────────────────────────────┘

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