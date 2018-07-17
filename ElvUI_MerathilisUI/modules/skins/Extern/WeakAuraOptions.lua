local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions

-- WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetAddOnInfo = GetAddOnInfo
-- GLOBALS:

local function InitStyleWAO()
	local function Skin_WeakAurasOptions(...)
		--print("Options opened", ...)
		if not IsAddOnLoaded("WeakAuras") or not E.private.muiSkins.addonSkins.wa then return end

		local frame = WeakAuras.OptionsFrame()
		if frame.skinned then return end

		local r, g, b = MER.ClassColor.r, MER.ClassColor.g, MER.ClassColor.b
		local children = {frame:GetChildren()}

		-- Close button
		children[1]:Hide()
		local close = children[1]:GetChildren()
		close:SetParent(frame)
		S:HandleCloseButton(close)

		-- Disable import check
		children[2]:Hide()
		local import = children[2]:GetChildren()
		S:HandleCheckBox(import)
		import:SetParent(frame)
		import:SetSize(25, 25)
		import:ClearAllPoints()
		import:SetPoint("LEFT", close, "RIGHT", 1, 0)

		-- Title
		--children[3]

		-- Frame size handle
		local sizer = children[4]
		sizer:SetNormalTexture("")
		sizer:SetHighlightTexture("")
		sizer:SetPushedTexture("")

		for i = 1, 3 do
			local tex = sizer:CreateTexture(nil, "OVERLAY")
			tex:SetSize(2, 2)
			tex:SetTexture(E["media"].normTex)
			tex:SetVertexColor(r, g, b, .8)
			tex:Show()
			sizer[i] = tex
		end
		sizer[1]:SetPoint("BOTTOMLEFT", sizer, "BOTTOMLEFT", 6, 6)
		sizer[2]:SetPoint("BOTTOMLEFT", sizer[1], "TOPLEFT", 0, 4)
		sizer[3]:SetPoint("BOTTOMLEFT", sizer[1], "BOTTOMRIGHT", 4, 0)

		-- Tutorial
		--children[6]
		local _, _, _, enabled, loadable = GetAddOnInfo("WeakAurasTutorials")
		local tutOfs = (enabled and loadable) and 1 or 0

		--[[ Ace groups
			children[6+tutOfs] container
			children[7+tutOfs] texturePick
			children[8+tutOfs] iconPick
			children[9+tutOfs] modelPick
			children[10+tutOfs] importexport
			children[11+tutOfs] texteditor
			children[12+tutOfs] codereview
			children[13+tutOfs] buttonsContainer
		]]

		-- Search
		S:HandleEditBox(WeakAurasFilterInput)

		-- Remove Title BG
		MERS:StripTextures(frame)

		-- StripTextures will actually remove the backdrop too, so we need to put that back
		MERS:CreateBD(frame)
		MERS:CreateSD(frame)
		frame:Styling()

		frame.skinned = true
	end
	hooksecurefunc(WeakAuras, "ShowOptions", Skin_WeakAurasOptions)
end

if IsAddOnLoaded("WeakAurasOptions") then
	InitStyleWAO()
else
	local load = CreateFrame("Frame")
	load:RegisterEvent("ADDON_LOADED")
	load:SetScript("OnEvent", function(self, _, addon)
		if addon ~= "WeakAurasOptions" then return end
		self:UnregisterEvent("ADDON_LOADED")

		InitStyleWAO()

		load = nil
	end)
end