local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleGuild()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true or E.private.muiSkins.blizzard.guild ~= true then return end

	MERS:CreateGradient(GuildFrame)
	if not GuildFrame.stripes then
		MERS:CreateStripes(GuildFrame)
	end
end

S:AddCallbackForAddon("Blizzard_GuildUI", "mUIGuild", styleGuild)