local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G

function module:TalkingHeadFrame()
	local frame = _G.TalkingHeadFrame
	if not frame then
		return
	end

	if not frame.MERStyle then
		F.CreateStyle(frame)
		print("TalkingHeadFrame styled.")
	end
end

module:AddCallback("TalkingHeadFrame")
print("MER_Skins: TalkingHeadFrame loaded.")
