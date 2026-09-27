local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

-- The Talking Head frame is not used on Forever
if E.Forever then
	return
end

local _G = _G

function module:TalkingHeadFrame()
	local frame = _G.TalkingHeadFrame
	if not frame then
		return
	end

	-- For some reason the style needs to applied later
	if not frame.MERStyle then
		F.CreateStyle(frame)
	end
end

module:AddCallback("TalkingHeadFrame")
