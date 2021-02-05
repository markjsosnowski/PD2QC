--Setup
_G.PD2QC = _G.PD2QC or {}
PD2QC.VERSION = "0.1"
if not _G.DelayedCallsFix then
    dofile(ModPath .. "lua/delayed_calls.lua")
end

--Main Script
PD2QC.PREV = nil

--TODO maybe also use this table for filling the hint gui
--IF YOU ARE LOOKING TO CHANGE THE CHAT MESSAGES
--DO SO IN THIS TABLE AND ONLY THIS TABLE
PD2QC.CHATS = {
    --Stealth
    LEFT={
        LEFT="Answer this pager.",
        UP="Use your ECM now!!",
        RIGHT="Bag this body.",
        DOWN="Keep a lookout."
    },
    --General
    UP={
        LEFT="You get it.", 
        UP="I got it.",
        RIGHT="I'm in trouble!",
        DOWN="Watch the civilians."
    },
    --Loud
    RIGHT={
        LEFT="Out of Ammunition!",
        UP="Need a doctor bag!",
        RIGHT="Help me with this!",
        DOWN="We should dominate cops."
    },
    --Orders
    DOWN={
        LEFT="Come here.",
        UP="Stay there.",
        RIGHT="Let's go.",
        DOWN="Take cover."
    }
}

PD2QC.VOICE ={} --TODO assign each command a relevant voice line

function PD2QC:SELECT(direction)
    if PD2QC.PREV ~= nil then
        --print(PD2QC.CHATS[PD2QC.PREV][direction])
        managers.chat:send_message(1,'?',PD2QC.CHATS[PD2QC.PREV][direction], Color.green)
        PD2QC:RESET()
    else
        PD2QC.PREV = direction
        PD2QC:BETA_HINTPOPUP(PD2QC.CHATS[direction])
        DelayedCallsFix:Add("PD2QCtimeout", 5, function()
            PD2QC:RESET()
        end)
        --TODO show relevant hint menu
    end
end

function PD2QC:RESET()
    PD2QC.PREV = nil
    DelayedCallsFix:Remove("PD2QCtimeout")
    --managers.chat:send_message(1,'?',"[PD2QC] Returning to catagory selection.", Color.red)
    --TODO hide hint menu
    --TODO show top menu if enabled
end

function PD2QC:BETA_HINTPOPUP(chat_table)
    _hint_message = "[PD2QC]\nUP:" .. chat_table["UP"] .. "\nLEFT:" .. chat_table["LEFT"] .. "\nRIGHT:" .. chat_table["RIGHT"] .. "\nDOWN:" .. chat_table["DOWN"]
    managers.chat:feed_system_message(ChatManager.GAME, _hint_message)
end
