local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = E:GetModule("muiSkins")
local S = E:GetModule("Skins")

local function styleTalkingHead()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.talkinghead ~= true or E.private.muiSkins.blizzard.talkinghead ~= true then return end

	local frame = _G["TalkingHeadFrame"]
	if frame then
		MERS:CreateGradient(frame)
		MERS:CreateStripes(frame)
		frame.BackgroundFrame:StripTextures()
		MERS:CreateBD(frame.BackgroundFrame, .25)
		MERS:CreateBD(frame.MainFrame.Model, .25)

		local button = frame.MainFrame.CloseButton
		button:ClearAllPoints()
		button:Point("TOPRIGHT", frame.BackgroundFrame, "TOPRIGHT", 0, -2)
	end
end

S:AddCallbackForAddon("Blizzard_TalkingHeadUI", "mUITalkingHead", styleTalkingHead)