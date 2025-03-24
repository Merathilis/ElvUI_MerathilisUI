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

	local AccountComplete = QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice
	AccountComplete:ClearAllPoints()
	AccountComplete:Point("LEFT", QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.BackButton, "RIGHT", 20, 0)
	AccountComplete.AccountCompletedIcon:Size(28)
	AccountComplete.AccountCompletedIcon:ClearAllPoints()
	AccountComplete.AccountCompletedIcon:Point("RIGHT", AccountComplete.Text, "LEFT", 1, 0)
end

module:AddCallback("QuestMapFrame")
