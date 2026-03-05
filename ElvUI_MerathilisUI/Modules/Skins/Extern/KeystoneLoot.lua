local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")
local S = E:GetModule("Skins")

-- Credits: Ndui_Plus

local function ReskinTabSystem(self)
	if not self.TabSystem then
		return
	end

	for _, tab in ipairs(self.TabSystem.tabs) do
		S:HandleTab(tab)
		tab.Text:ClearAllPoints()
		tab.Text:SetPoint("CENTER")
		tab.Text.SetPoint = E.noop
		tab.leftPadding = -16
	end
end

function module:KeystoneLoot()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.klf then
		return
	end

	local frame = _G.KeystoneLootFrame
	if not frame then
		return
	end

	S:HandlePortraitFrame(frame)
	WS:CreateShadow(frame)

	S:HandleDropDownBox(frame.SlotDropdown)
	S:HandleDropDownBox(frame.ClassDropdown)
	S:HandleDropDownBox(frame.ItemLevelDropdown)
	MER:SecureHook(frame, "InitializeTabSystem", ReskinTabSystem)

	local SettingsDropdown = frame.SettingsDropdown
	if SettingsDropdown then
		SettingsDropdown:ClearAllPoints()
		SettingsDropdown:SetPoint("TOPRIGHT", -28, -6)
	end

	local CatalystFrame = frame.CatalystFrame
	if CatalystFrame then
		CatalystFrame:ClearAllPoints()
		CatalystFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 0, -40)
		CatalystFrame.Border:StripTextures()
		CatalystFrame:CreateBackdrop("Transparent")
		CatalystFrame.backdrop:SetInside()
	end

	-- ReminderFrame
	local ReminderFrame = _G.KeystoneLootReminderFrame
	if ReminderFrame then
		S:HandlePortraitFrame(ReminderFrame)
	end
end

module:AddCallbackForAddon("KeystoneLoot")
