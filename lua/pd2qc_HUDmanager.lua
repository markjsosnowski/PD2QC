if not _G.PD2QC then
    dofile(ModPath .. "lua/pd2qc.lua")
end

local function getMinWith(table)
    --TODO change this to use a keybind table instead of string literals
    local min = #table["LEFT"] + #table["RIGHT"] + #"LEFT" + #"RIGHT"
    if(#table["UP"] > min) then
        min = #table["UP"]
    end
    if(#table["DOWN"] > min) then
        min = #table["DOWN"]
    end
    return (min * 10) - min
end

function PD2QC:CreatePanelFromTable(table)
    local hint_panel_settings = {}

    hint_panel_settings.min_width = getMinWith(table)
    hint_panel_settings.min_height = 90
    hint_panel_settings.padding = 2
    hint_panel_settings.center_x = 0.75 --todo
    hint_panel_settings.center_y = 0.70

    hint_panel_settings.background = {}
    hint_panel_settings.background.alpha = 0.75
    hint_panel_settings.background.color = Color.black
    hint_panel_settings.background.layer = 1

    hint_panel_settings.text = {}
    
    hint_panel_settings.text= {}
    hint_panel_settings.text.font = tweak_data.hud_present.text_font
    hint_panel_settings.text.size = math.floor(tweak_data.hud_present.text_size/1.5)
    hint_panel_settings.text.color = Color.white
    hint_panel_settings.text.layer = 2

--┌──────────────────────────────────────────┐
--│               Up Message                 │
--│                  [UP]                    │
--│Left Message [LEFT]  [RIGHT] Right Message│
--│                 [DOWN]                   │
--│              Down Message                │
--└──────────────────────────────────────────┘
--Todo dynamically write min width based on longest message
--Todo put keybinds in a table and refernce them instead of string literals
    hint_panel_settings.text_items = {}
    hint_panel_settings.text_items[0] = {}
    hint_panel_settings.text_items[0].value = table["UP"] .. "\n[UP]"
    hint_panel_settings.text_items[1] = {}
    hint_panel_settings.text_items[1].value = "\n\n" .. table["LEFT"] .. " [LEFT]" 
    hint_panel_settings.text_items[2] = {}
    hint_panel_settings.text_items[2].value = "\n\n[RIGHT] " .. table["RIGHT"]
    hint_panel_settings.text_items[3] = {}
    hint_panel_settings.text_items[3].value= "\n\n\n[DOWN]\n" .. table["DOWN"]
    return hint_panel_settings
end

function PD2QC:ShowHintPanel(table)
    local hint_panel_settings = PD2QC:CreatePanelFromTable(table)

    local layer = tweak_data.gui.DIALOG_LAYER + 100
    local pd2qc_panel = PD2QC:newPanel(PD2QC:getHudPanel(), "pd2qc_panel", layer)
    PD2QC.hint_panel = pd2qc_panel
    layer = layer + 10
    local pd2qc_container_panel = PD2QC:newPanel(pd2qc_panel, "pd2qc_container_panel", layer)
    layer = layer + 10
    local pd2qc_bacground_rect = PD2QC:newRect(pd2qc_container_panel, "pd2qc_background_rect", layer, hint_panel_settings.background.color, hint_panel_settings.background.alpha)
    layer = layer + 10
    --local pd2qc_padding_panel = PD2QC:newPanel(pd2qc_container_panel, "pd2qc_padding_panel", layer)
    --layer = layer + 10

    --TODO header?
    hint_panel_settings.text_items[0].text_panel = PD2QC:newText(pd2qc_container_panel, "up", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[0].value, "center", "center","grow")
    hint_panel_settings.text_items[1].text_panel = PD2QC:newText(pd2qc_container_panel, "left", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[1].value, "left", "grow","grow")
    hint_panel_settings.text_items[2].text_panel = PD2QC:newText(pd2qc_container_panel, "right", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[2].value, "right", "right","grow")
    hint_panel_settings.text_items[3].text_panel = PD2QC:newText(pd2qc_container_panel, "down", layer, hint_panel_settings.text.font, hint_panel_settings.text.size, hint_panel_settings.text.color, hint_panel_settings.text_items[3].value, "center", "center","grow")

    --pd2qc_padding_panel:set_width(hint_panel_settings.min_width)
    --pd2qc_padding_panel:set_height(hint_panel_settings.min_height)
    --pd2qc_padding_panel:set_center_x(math.floor())
    pd2qc_container_panel:set_width(hint_panel_settings.min_width + hint_panel_settings.padding)
    pd2qc_container_panel:set_height(hint_panel_settings.min_height + hint_panel_settings.padding)

    local centerX = math.floor(pd2qc_panel:width() * hint_panel_settings.center_x)
    local centerY = math.floor(pd2qc_panel:height() * hint_panel_settings.center_y)
    pd2qc_container_panel:set_center_x(centerX)
    pd2qc_container_panel:set_center_y(centerY)

    --pd2qc_padding_panel:set_left(hint_panel_settings.padding)
    --pd2qc_padding_panel:set_top(hint_panel_settings.padding)
end

function PD2QC:RemoveHintPanel()
    if PD2QC.hint_panel ~= nil then
        PD2QC:getHudPanel():remove(PD2QC.hint_panel)
        PD2QC.hint_panel = nil
    end
end

function PD2QC:getHudPanel()
    return managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel
end

function PD2QC:newPanel(panel, name, layer)
    local panel_data = {
        name = name,
        layer = layer
    }
    return panel:panel(panel_data)
end

function PD2QC:newRect(panel, name, layer, color, alpha)
    local rect_data= {
        name = name,
        layer = layer,
        visible = true, 
        color = color,
        alpha = alpha
    }
    return panel:rect(rect_data)
end

function PD2QC:newText(panel, name, layer, font, font_size, color, text, align, halign, valign)
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