--Setup
if not _G.PD2QC then
    _G.PD2QC = {}
    dofile(ModPath .. "lua/pd2qc_HUDmanager.lua")
    PD2QC.VERSION = "0.1"
end

if not _G.DelayedCallsFix then
    dofile(ModPath .. "lua/delayed_calls.lua")
end

--IF YOU DON'T KNOW WHAT YOU ARE DOING
--ONLY CHANGE THINGS INSIDE THIS BOX
--───────────────────────────────────────────────────────────┐

--These will later be changable in Mod Options
PD2QC.SETTINGS = {
    persistant_menu = false,
    --voices_enabled = false,
    --0: Vanilla HUD (Lower Left); 1: WolfHUD (Middle Right)
    --hud_placement = 0
}

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
        RIGHT="I'm in trouble!",
        DOWN="Take hostages."
    },
    RIGHT={
        LEFT="Out of Ammunition!",
        UP="Need Doctor Bag!",
        RIGHT="Help me kill this!",
        DOWN="Sniper here, watch out!"
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
PD2QC.CATAGORY = {
    LEFT = "Stealth",
    UP = "General",
    RIGHT = "Loud",
    DOWN = "Orders"
}
--───────────────────────────────────────────────────────────┘

PD2QC.VOICE ={} --TODO assign each command a relevant voice line

--Main Script
PD2QC.PREV = nil

--if PD2QC.SETTINGS.persistant_menu and Utils:IsInHeist() then
--    PD2QC:ShowHintPanel(PD2QC.CATAGORY)
--end

function PD2QC:SELECT(direction)
    if PD2QC.PREV then
        managers.chat:send_message(1,'?',PD2QC.CHATS[PD2QC.PREV][direction], Color.green)
        PD2QC:RESET()
    else
        PD2QC.PREV = direction
        if PD2QC.SETTINGS.persistant_menu then
            PD2QC:RemoveHintPanel()
        end
        PD2QC:ShowHintPanel(PD2QC.CHATS[direction])
        DelayedCallsFix:Add("PD2QCtimeout", 5, function()
            PD2QC:RESET()
        end)
    end
end

function PD2QC:RESET()
    PD2QC.PREV = nil
    PD2QC:RemoveHintPanel()
    DelayedCallsFix:Remove("PD2QCtimeout")
    if(PD2QC.SETTINGS.persistant_menu) then
        PD2QC:ShowHintPanel(PD2QC.CATAGORY)
    end
end

--For Testing, Not Used. Prints a system message instead of a HUD element of the choices.
function PD2QC:BETA_HINTPOPUP(chat_table)
    _hint_message = "[PD2QC]\nUP:" .. chat_table["UP"] .. "\nLEFT:" .. chat_table["LEFT"] .. "\nRIGHT:" .. chat_table["RIGHT"] .. "\nDOWN:" .. chat_table["DOWN"]
    managers.chat:feed_system_message(ChatManager.GAME, _hint_message)
end