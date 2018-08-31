local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G

--WoW API / Variables

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleRaid()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.raid ~= true or E.private.muiSkins.blizzard.raid ~= true then return end

	local function onEnter(self)
		if self.class then
			self:SetBackdropBorderColor(CUSTOM_CLASS_COLORS[self.class].r, CUSTOM_CLASS_COLORS[self.class].g, CUSTOM_CLASS_COLORS[self.class].b)
		else
			self:SetBackdropBorderColor(0.5, 0.5, 0.5)
		end
	end

	local function onLeave(self)
		self:SetBackdropBorderColor(0, 0, 0)
	end

	for grpNum = 1, 8 do
		local name = "RaidGroup"..grpNum
		local group = _G[name]
		group:GetRegions():Hide()
		for slotNum = 1, 5 do
			local slot = _G[name.."Slot"..slotNum]
			slot:SetHighlightTexture("")
			MERS:CreateBD(slot, 0.5)

			slot:HookScript("OnEnter", onEnter)
			slot:HookScript("OnLeave", onLeave)
		end
	end

	for btnNum = 1, 40 do
		local name = "RaidGroupButton"..btnNum
		local btn = _G[name]
		MERS:Reskin(btn, true)

		btn:HookScript("OnEnter", onEnter)
		btn:HookScript("OnLeave", onLeave)
	end
end

S:AddCallbackForAddon("Blizzard_RaidUI", "mUIRaidUI", styleRaid)