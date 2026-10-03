local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local ipairs = ipairs

-- Cropped to the unit frames and action bars, at the width : height of the preset cards
local PREVIEW_COORDS = { 0.22, 0.78, 0.6, 0.956 }

F.Presets.Register({
	key = "minimal",
	name = L["Minimal"],
	desc = L["Only the main action bar stays visible, the other bars show on mouseover. No chat backgrounds, chat bar or portraits."],
	base = "dark",
	preview = [[Interface\AddOns\ElvUI_MerathilisUI\Media\Textures\Presets\Minimal.tga]],
	previewCoords = PREVIEW_COORDS,
	apply = function()
		local bars = E.db.actionbar

		for _, bar in ipairs({ "bar2", "bar3", "bar6" }) do
			bars[bar].mouseover = true
		end

		-- No backdrop behind the buttons, it also spans the rows of bars 2 and 3
		bars.bar1.backdrop = false

		E.db.chat.panelBackdrop = "HIDEBOTH"

		-- Runs after the WindTools and mMediaTag setup of the preset, so it overrides it
		E.db.WT.social.chatBar.enable = false

		local mMediaTag = E.db.mMediaTag
		if mMediaTag and mMediaTag.portraits then
			mMediaTag.portraits.enable = false
		end

		-- The MerathilisUI resting indicator sits next to the portrait, ElvUI's own one on the frame
		E.db.mui.unitframes.restingIndicator.enable = false
		E.db.unitframe.units.player.RestIcon.xOffset = -3
		E.db.unitframe.units.player.RestIcon.yOffset = 6
	end,
})
