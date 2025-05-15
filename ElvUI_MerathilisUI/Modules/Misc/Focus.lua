local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local oUF = E.oUF

-- Credits: NDUI (siweia)

local _G = _G
local next, strmatch = next, string.match
local InCombatLockdown = InCombatLockdown

local modifier = "shift" -- shift, alt or ctrl
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any
local pending = {}

function module:Focuser_Setup()
	if not self or self.focuser then
		return
	end

	local name = self.GetName and self:GetName()
	if name and strmatch(name, "oUF_NPs") then
		return
	end

	if not InCombatLockdown() then
		self:SetAttribute(modifier .. "-type" .. mouseButton, "focus")
		self.focuser = true
		pending[self] = nil
	else
		pending[self] = true
	end
end

function module:Focuser_CreateFrameHook(name, _, template)
	if name and template == "SecureUnitButtonTemplate" then
		module.Focuser_Setup(_G[name])
	end
end

function module.Focuser_OnEvent(event)
	if event == "PLAYER_REGEN_ENABLED" then
		if next(pending) then
			for frame in next, pending do
				module.Focuser_Setup(frame)
			end
		end
	else
		for _, object in next, oUF.objects do
			if not object.focuser then
				module.Focuser_Setup(object)
			end
		end
	end
end

function module:Focuser()
	if not E.db.mui.misc.focuser.enable then
		return
	end

	-- Keybinding override so that models can be shift/alt/ctrl+clicked
	local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
	f:SetAttribute("type1", "macro")
	f:SetAttribute("macrotext", "/focus mouseover")
	SetOverrideBindingClick(FocuserButton, true, modifier .. "-BUTTON" .. mouseButton, "FocuserButton")
	f:RegisterForClicks("LeftButtonUp", "LeftButtonDown")

	hooksecurefunc("CreateFrame", module.Focuser_CreateFrameHook)
	module:Focuser_OnEvent()
	MER:RegisterEvent("PLAYER_REGEN_ENABLED", module.Focuser_OnEvent)
	MER:RegisterEvent("GROUP_ROSTER_UPDATE", module.Focuser_OnEvent)
end

module:AddCallback("Focuser")
