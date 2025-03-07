local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local select = select

function module:QuestMapFrame()
	if not module:CheckDB("quest", "quest") then
		return
	end

	local QuestMapFrame = _G.QuestMapFrame
	local DetailsFrame = QuestMapFrame.DetailsFrame
end

module:AddCallback("QuestMapFrame")
