if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

local function GetKeybind(id)
    local nb = "Not Bound"
    local bind = BLT.Keybinds:get_keybind(id)
    if bind ~= nil then
        return string.upper(tostring(bind:Key()))
    else
        return nb
    end
end

local function GetMinWidth(table)
    local min = #table["LEFT"] + #table["RIGHT"] + #GetKeybind("pd2qc_left") + #GetKeybind("pd2qc_right")
    -- (math.abs(#table["LEFT"] - #table["RIGHT"]) / 2)
    if(#table["UP"] > min) then
        min = #table["UP"]
    end
    if(#table["DOWN"] > min) then
        min = #table["DOWN"]
    end
    return (min * 7.5)
end

local function GetHUDPos()
    if PD2QC._settings.hud_placement == 1 then
        return 0.2, 0.9
    elseif PD2QC._settings.hud_placement == 2 then
        return 0.85, 0.7
    elseif PD2QC._settings.hud_placement == 3 then
        return 0.5, 0.8
    end
    return 0.2, 0.9
end

function PD2QC:CreatePanelFromTable(table)
    local hint_panel_settings = {}

    hint_panel_settings.min_width = GetMinWidth(table)
    hint_panel_settings.min_height = 96
    hint_panel_settings.padding = 5
    
    hint_panel_settings.center_x, hint_panel_settings.center_y = GetHUDPos()

    hint_panel_settings.background = {}
    hint_panel_settings.background.alpha = 0.75
    hint_panel_settings.background.color = Color.black
    hint_panel_settings.background.layer = 1
    
    hint_panel_settings.text = {}
    hint_panel_settings.text.font = tweak_data.hud_present.text_font
    hint_panel_settings.text.size = math.floor(tweak_data.hud_present.text_size/1.5)
    hint_panel_settings.text.color = Color.white
    hint_panel_settings.text.layer = 2

    --Ends up looking like this:
    --┌──────────────────────────────────────────┐
    --│               Up Message                 │
    --│                  [UP]                    │
    --│Left Message [LEFT]  [RIGHT] Right Message│
    --│                 [DOWN]                   │
    --│              Down Message                │
    --└──────────────────────────────────────────┘
    hint_panel_settings.text_items = {}
    hint_panel_settings.text_items[0] = {}
    hint_panel_settings.text_items[0].value = table["UP"] .. "\n[" .. GetKeybind("pd2qc_up") .. "]"
    hint_panel_settings.text_items[1] = {}
    hint_panel_settings.text_items[1].value = "\n\n" .. table["LEFT"] .. " [" .. GetKeybind("pd2qc_left").. "]"
    hint_panel_settings.text_items[2] = {}
    hint_panel_settings.text_items[2].value = "\n\n[" .. GetKeybind("pd2qc_right") .. "] " .. table["RIGHT"]
    hint_panel_settings.text_items[3] = {}
    hint_panel_settings.text_items[3].value= "\n\n\n[" .. GetKeybind("pd2qc_down") .. "]\n" .. table["DOWN"]
    return hint_panel_settings
end

function PD2QC:ShowHintPanel(table)
    local hint_panel_settings = PD2QC:CreatePanelFromTable(table)

    local layer = tweak_data.gui.DIALOG_LAYER + 100
    local pd2qc_panel = PD2QC:NewPanel(PD2QC:GetHudPanel(), "pd2qc_panel", layer)
    PD2QC.hint_panel = pd2qc_panel
    layer = layer + 10
    local pd2qc_container_panel = PD2QC:NewPanel(pd2qc_panel, "pd2qc_container_panel", layer)
    layer = layer + 10
    local pd2qc_bacground_rect = PD2QC:NewRect(pd2qc_container_panel, "pd2qc_background_rect", layer, hint_panel_settings.background.color, hint_panel_settings.background.alpha)
    layer = layer + 10

    hint_panel_settings.text_items[0].text_panel = PD2QC:NewText(pd2qc_container_panel, "up", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[0].value, "center", "center","grow")
    hint_panel_settings.text_items[1].text_panel = PD2QC:NewText(pd2qc_container_panel, "left", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[1].value, "left", "grow","grow")
    hint_panel_settings.text_items[2].text_panel = PD2QC:NewText(pd2qc_container_panel, "right", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[2].value, "right", "right","grow")
    hint_panel_settings.text_items[3].text_panel = PD2QC:NewText(pd2qc_container_panel, "down", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[3].value, "center", "center","grow")

    pd2qc_container_panel:set_width(hint_panel_settings.min_width + hint_panel_settings.padding)
    pd2qc_container_panel:set_height(hint_panel_settings.min_height + hint_panel_settings.padding)

    local centerX = math.floor(pd2qc_panel:width() * hint_panel_settings.center_x)
    local centerY = math.floor(pd2qc_panel:height() * hint_panel_settings.center_y)
    pd2qc_container_panel:set_center_x(centerX)
    pd2qc_container_panel:set_center_y(centerY)
end

function PD2QC:RemoveHintPanel()
    if PD2QC.hint_panel then
        PD2QC:GetHudPanel():remove(PD2QC.hint_panel)
        PD2QC.hint_panel = nil
    end
end

function PD2QC:GetHudPanel()
    return managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel
end

function PD2QC:NewPanel(panel, name, layer)
    local panel_data = {
        name = name,
        layer = layer
    }
    return panel:panel(panel_data)
end

function PD2QC:NewRect(panel, name, layer, color, alpha)
    local rect_data= {
        name = name,
        layer = layer,
        visible = true,
        color = color,
        alpha = alpha
    }
    return panel:rect(rect_data)
end

function PD2QC:NewText(panel, name, layer, font, font_size, color, text, align, halign, valign)
	local text_data = {
		name = name,
		layer = layer,
		font = font,
		font_size = font_size,
		color = color,
		text = text,
		wrap = false,
		word_wrap = false,
		align = align,
		halign = halign,
		valign = valign
    }
    return panel:text(text_data)
end

--Hides the HUD when the pause menu (ESC) is opened
Hooks:PreHook(MenuPauseRenderer, "open", "pd2qc_pause_open", function()
    PD2QC._paused = true
    if PD2QC._settings.pausable then
        PD2QC:RESET()
    end
end)

Hooks:PreHook(MenuPauseRenderer, "close", "pd2qc_pause_close", function()
    PD2QC._paused = false
    if(PD2QC._settings.persist) then
        PD2QC:ShowHintPanel(PD2QC.CATEGORY)
    end
end)