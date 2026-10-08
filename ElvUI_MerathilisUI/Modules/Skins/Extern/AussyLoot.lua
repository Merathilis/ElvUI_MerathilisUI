local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local _G = _G
local next = next

local hooksecurefunc = hooksecurefunc

-- AussyLoot draws everything itself through AL:Paint (a 1px WHITE8x8 backdrop)
-- and a theme layer that repaints every painted frame on a theme change. Its
-- accents, item qualities and status colors carry meaning, so they are left
-- alone; only the window chrome (backdrops, background art, fonts) is swapped
-- for the ElvUI look.

-- AL:Paint and the theme refresh both call SetBackdrop on the frame again, which
-- would draw AussyLoot's opaque fill above the ElvUI backdrop child. Clearing it
-- right after every SetBackdrop keeps the frame bare whichever path repaints it.
-- The backdrop color setters silently no-op without backdrop info.
local function ClearOwnBackdrop(frame)
	frame:SetBackdrop(nil)

	if not frame.MERBackdropHooked then
		frame.MERBackdropHooked = true
		hooksecurefunc(frame, "SetBackdrop", function(self, info)
			if info then
				self:SetBackdrop(nil)
			end
		end)
	end
end

-- Background art, gradients, vignette and corner brackets are plain textures on
-- the frame itself. The theme layer only recolors them, it never touches alpha.
local function HideTextures(frame)
	for _, region in next, { frame:GetRegions() } do
		if region:IsObjectType("Texture") then
			region:SetAlpha(0)
		end
	end
end

local function SkinPanel(frame, hideTextures)
	if not frame or frame.MERSkinned then
		return
	end
	frame.MERSkinned = true

	ClearOwnBackdrop(frame)
	if hideTextures then
		HideTextures(frame)
	end

	frame:CreateBackdrop("Transparent")
	WS:CreateShadow(frame.backdrop)
end

local function SkinHeader(header)
	ClearOwnBackdrop(header)

	-- The window's background art, cropped to the header (ARTWORK -8). The brand
	-- bloom (-7) and the accent rule underneath stay.
	for _, region in next, { header:GetRegions() } do
		if region:IsObjectType("Texture") then
			local layer, sublevel = region:GetDrawLayer()
			if layer == "ARTWORK" and sublevel == -8 then
				region:SetAlpha(0)
			end
		end
	end
end

local function SkinMainWindow()
	local frame = _G.AussyLoot.MainWindow
	if not frame or frame.MERSkinned then
		return
	end

	SkinPanel(frame, true)

	if frame.header then
		SkinHeader(frame.header)
	end
end

local function SkinMenu()
	SkinPanel(_G.AussyLootMenu)
end

local function SkinCopyText()
	SkinPanel(_G.AussyLoot.copyTextFrame, true)
end

local function SkinPasteBox()
	local frame = _G.AussyLoot.pasteBox
	if not frame or frame.MERSkinned then
		return
	end

	SkinPanel(frame)

	-- The only scroll frame AussyLoot does not run through its own StyleScrollBar
	for _, child in next, { frame:GetChildren() } do
		for _, scroll in next, { child:GetChildren() } do
			if scroll:IsObjectType("ScrollFrame") and scroll.ScrollBar then
				S:HandleScrollBar(scroll.ScrollBar)
			end
		end
	end
end

-- The welcome overlay is an anonymous full-cover child of the main window that
-- holds the actual card, so it is found through the window's children.
local function SkinWelcome()
	local window = _G.AussyLoot.MainWindow
	if not window then
		return
	end

	for _, child in next, { window:GetChildren() } do
		local card = child.card
		if card and not card.MERSkinned then
			SkinPanel(card)

			-- The window's background art (BACKGROUND 1); the brand watermark stays
			for _, region in next, { card:GetRegions() } do
				if region:IsObjectType("Texture") then
					local layer, sublevel = region:GetDrawLayer()
					if layer == "BACKGROUND" and sublevel == 1 then
						region:SetAlpha(0)
					end
				end
			end
		end
	end
end

local function SkinToast(alerts)
	local toast = alerts.toast
	if not toast or toast.MERSkinned then
		return
	end

	SkinPanel(toast)

	if toast.icon then
		S:HandleIcon(toast.icon, true)
	end
end

function module:AussyLoot()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.aussyLoot then
		return
	end

	local AL = _G.AussyLoot
	if not AL or not AL.Fonts then
		return
	end

	-- A font set by hand through AussyLootDB.fontOverride wins. The wordmark
	-- (AL.Fonts.title) is part of the brand and stays.
	if not (_G.AussyLootDB and _G.AussyLootDB.fontOverride) then
		AL.Fonts.body = E.media.normFont
		AL.Fonts.display = E.media.normFont
		AL.Fonts.dense = E.media.normFont
	end

	-- Every frame is built lazily on first use
	hooksecurefunc(AL, "CreateMainWindow", SkinMainWindow)
	hooksecurefunc(AL, "ShowMenu", SkinMenu)
	hooksecurefunc(AL, "ShowCopyText", SkinCopyText)
	hooksecurefunc(AL, "ShowPasteBox", SkinPasteBox)

	if AL.Welcome then
		hooksecurefunc(AL.Welcome, "Show", SkinWelcome)
	end

	if AL.DropAlerts then
		hooksecurefunc(AL.DropAlerts, "Next", SkinToast)
	end

	SkinMainWindow()
end

module:AddCallbackForAddon("AussyLoot")
