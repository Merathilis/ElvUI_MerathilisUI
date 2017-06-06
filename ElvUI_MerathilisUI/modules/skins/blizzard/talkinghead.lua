local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleTalkingHead()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talkinghead ~= true or E.private.muiSkins.blizzard.talkinghead ~= true then return end

	MERS:CreateGradient(TalkingHeadFrame)

end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "mUITalkingHead", styleTalkingHead)