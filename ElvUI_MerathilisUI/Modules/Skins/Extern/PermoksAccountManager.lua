local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

local pairs = pairs

-- Every PAM frame border (main window, drag bar, category window, category
-- button background) goes through PAM:UpdateBorder, which puts a 5px edge
-- backdrop on it. PAM calls it again for frames it creates later, and
-- UpdateBorderColor recolors all of them when its border color option changes,
-- so both are hooked and our look is applied after PAM's own every time.
-- The LibQTip tooltips are left to WindTools' LibQTip skin.
local skinnedBackdrops = {}

local function SkinBackdrop(backdrop)
	if not backdrop then
		return
	end

	backdrop:SetTemplate("Transparent")

	if not skinnedBackdrops[backdrop] then
		skinnedBackdrops[backdrop] = true
		F.CreateStyle(backdrop)
		WS:CreateShadow(backdrop)
	end
end

-- PAM already hands these buttons to ElvUI's HandleButton; its Blizzard atlas
-- for the selected state stays on top of that, so it becomes a class color tint.
local function SkinManagerButton(button)
	if not button or button.MERSkinned then
		return
	end
	button.MERSkinned = true

	if button.normalTexture then
		button.normalTexture:SetAlpha(0)
	end

	local selected = button.selected
	if selected then
		local r, g, b = F.r, F.g, F.b
		selected:SetTexture(E.media.blankTex)
		selected:SetVertexColor(r, g, b, 0.25)
		selected:ClearAllPoints()
		selected:SetInside(button)
	end

	WS:CreateShadow(button)
end

-- PAM lets its frames overlap by its 5px edge (the main border reaches 5px up
-- into the drag bar, the category button background 5px into the main window,
-- the category window sits 2px below). With a 1px border and shadows that
-- reads as frames running into each other, so every frame gets a real gap.
-- PAM anchors these once on creation, the category buttons on every update.
local PAM_EDGE = 5
local FRAME_GAP = 6

local function LayoutFrames(PAM)
	local managerFrame = PAM.managerFrame
	if not managerFrame then
		return
	end

	local dragBar = managerFrame.topDragBar
	if dragBar then
		dragBar:ClearAllPoints()
		dragBar:SetPoint("BOTTOMLEFT", managerFrame, "TOPLEFT", -PAM_EDGE, PAM_EDGE + FRAME_GAP)
		dragBar:SetPoint("BOTTOMRIGHT", managerFrame, "TOPRIGHT", PAM_EDGE, PAM_EDGE + FRAME_GAP)
	end

	local categoryFrame = managerFrame.categoryFrame
	if categoryFrame then
		local y = -(PAM_EDGE * 2 + FRAME_GAP)
		categoryFrame:ClearAllPoints()
		categoryFrame:SetPoint("TOPLEFT", managerFrame, "BOTTOMLEFT", 0, y)
		categoryFrame:SetPoint("TOPRIGHT", managerFrame, "BOTTOMRIGHT", 0, y)
	end
end

local function LayoutCategoryBackground(PAM)
	local managerFrame = PAM.managerFrame
	local background = managerFrame and managerFrame.categoriesBackgroundFrame
	if background and managerFrame.topDragBar then
		background:ClearAllPoints()
		background:SetPoint("TOPRIGHT", managerFrame.topDragBar, "TOPLEFT", -FRAME_GAP, 0)
	end
end

local function SkinManagerButtons(PAM)
	local managerFrame = PAM.managerFrame
	if not managerFrame then
		return
	end

	for _, button in pairs(managerFrame.categoryButtons or {}) do
		SkinManagerButton(button)

		-- Moved left with their background, keeping PAM's 5px inset on the right
		if button:IsShown() then
			local point, relativeTo, relativePoint, _, y = button:GetPoint(1)
			if point == "TOPRIGHT" and relativeTo == managerFrame.topDragBar then
				button:SetPoint(point, relativeTo, relativePoint, -FRAME_GAP - PAM_EDGE, y)
			end
		end
	end

	for _, button in pairs(managerFrame.pageButtons or {}) do
		SkinManagerButton(button)
	end
end

local function SkinCloseButton(PAM)
	local closeButton = PAM.managerFrame and PAM.managerFrame.closeButton
	if not closeButton or closeButton.MERSkinned then
		return
	end
	closeButton.MERSkinned = true

	if closeButton.x then
		closeButton.x:SetAlpha(0)
	end

	S:HandleCloseButton(closeButton)
end

function module:PermoksAccountManager()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.pam then
		return
	end

	-- PAM keeps its addon object in a file local, there is no global for it
	local PAM = E.Libs.AceAddon:GetAddon("PermoksAccountManager", true)
	if not PAM or not PAM.UpdateBorder then
		return
	end

	hooksecurefunc(PAM, "UpdateBorder", function(_, backdrop)
		SkinBackdrop(backdrop)
	end)

	hooksecurefunc(PAM, "UpdateBorderColor", function()
		for backdrop in pairs(skinnedBackdrops) do
			SkinBackdrop(backdrop)
		end
	end)

	hooksecurefunc(PAM, "CreateFrames", LayoutFrames)
	-- The close button is built the first time the window opens
	hooksecurefunc(PAM, "CreateMenuButtons", SkinCloseButton)
	hooksecurefunc(PAM, "UpdateCategoryButtonsBackground", LayoutCategoryBackground)
	hooksecurefunc(PAM, "UpdateOrCreateCategoryButtons", SkinManagerButtons)
	hooksecurefunc(PAM, "UpdatePageButtons", SkinManagerButtons)

	-- PAM builds its main frames on its own ADDON_LOADED, which may have run before this
	local managerFrame = PAM.managerFrame
	if managerFrame then
		SkinBackdrop(managerFrame.backdrop)
		SkinBackdrop(managerFrame.topDragBar)
		SkinBackdrop(managerFrame.categoriesBackgroundFrame)
		SkinBackdrop(managerFrame.categoryFrame and managerFrame.categoryFrame.backdrop)
		LayoutFrames(PAM)
		LayoutCategoryBackground(PAM)
		SkinCloseButton(PAM)
		SkinManagerButtons(PAM)
	end
end

module:AddCallbackForAddon("PermoksAccountManager")
