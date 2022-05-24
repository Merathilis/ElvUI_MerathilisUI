local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G
local select, unpack = select, unpack

local r, g, b = unpack(E["media"].rgbvaluecolor)

function module:Blizzard_RaidUI()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.raid ~= true or E.private.mui.skins.blizzard.raid ~= true then return end

	for i = 1, _G.NUM_RAID_GROUPS do
		local group = _G["RaidGroup"..i]
		group:GetRegions():SetAlpha(0)
		for j = 1, _G.MEMBERS_PER_RAID_GROUP do
			local slot = _G["RaidGroup"..i.."Slot"..j]
			select(1, slot:GetRegions()):SetAlpha(0)
			select(2, slot:GetRegions()):SetColorTexture(r, g, b, .25)
			module:CreateBDFrame(slot, .2)
		end
	end

	for i = 1, _G.MAX_RAID_MEMBERS do
		local bu = _G["RaidGroupButton"..i]
		select(4, bu:GetRegions()):SetAlpha(0)
		select(5, bu:GetRegions()):SetColorTexture(r, g, b, .2)
		module:CreateBDFrame(bu)
	end
end

module:AddCallbackForAddon("Blizzard_RaidUI")
