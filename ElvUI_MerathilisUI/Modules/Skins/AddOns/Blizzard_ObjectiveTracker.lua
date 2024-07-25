local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
}

function module:Blizzard_ObjectiveTracker()
	if not module:CheckDB("objectiveTracker", "objectiveTracker") then
		return
	end

	for _, tracker in pairs(trackers) do
		if tracker then
		end
	end
end

module:AddCallbackForAddon("Blizzard_ObjectiveTracker")
