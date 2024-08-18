local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

local function cbResize(self, event, ...)
	for i = 1, 20 do
		local checkbox = _G["ACP_AddonListEntry" .. i .. "Enabled"]
		local collapse = _G["ACP_AddonListEntry" .. i .. "Collapse"]
		checkbox:SetPoint("LEFT", 5, 0)
		checkbox:SetSize(26, 26)

		if not collapse:IsShown() then
			checkbox:SetPoint("LEFT", 15, 0)
			checkbox:SetSize(20, 20)
		end
	end
end

local function HandleDropdown(frame)
	frame:Width(200)
	frame:Height(32)
	frame:StripTextures()
	frame:CreateBackdrop()
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:Point("TOPLEFT", 20, 1)
	frame.backdrop:Point("BOTTOMRIGHT", frame.Button, "BOTTOMRIGHT", 2, -2)
	S:HandleNextPrevButton(frame.Button, "down")
	frame.Text:ClearAllPoints()
	frame.Text:Point("RIGHT", frame.Button, "LEFT", -2, 0)
end

function module:ACP()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.acp then
		return
	end

	module:DisableAddOnSkins("ACP", false)

	S:HandleFrame(_G.ACP_AddonList, true, nil, 10, nil, -30)
	module:CreateBackdropShadow(_G.ACP_AddonList)

	HandleDropdown(_G.ACP_AddonListSortDropDown)
	S:HandleScrollBar(_G.ACP_AddonList_ScrollFrameScrollBar)

	S:HandleButton(_G.ACP_AddonListSetButton)
	S:HandleButton(_G.ACP_AddonListDisableAll)
	S:HandleButton(_G.ACP_AddonListEnableAll)
	S:HandleButton(_G.ACP_AddonList_ReloadUI)
	S:HandleButton(_G.ACP_AddonListBottomClose)

	S:HandleCheckBox(_G.ACP_AddonList_NoRecurse)
	S:HandleCheckBox(_G.ACPAddonListForceLoad)

	for i = 1, 20 do
		S:HandleButton(_G["ACP_AddonListEntry" .. i .. "LoadNow"])
		S:HandleCheckBox(_G["ACP_AddonListEntry" .. i .. "Enabled"])
	end

	_G.ACP_AddonListBottomClose:SetPoint("BOTTOMRIGHT", _G.ACP_AddonList, "BOTTOMRIGHT", -74, 20)

	hooksecurefunc(_G.ACP, "AddonList_OnShow_Fast", cbResize)
end

module:AddCallbackForAddon("ACP")
