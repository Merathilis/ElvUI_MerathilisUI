local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

local hooksecurefunc = hooksecurefunc

function module:Construct_PartyFrames()
	if not self.isChild then
		self.DeathIndicator = module:Construct_DeathIndicator(self)
		self.OfflineIndicator = module:Construct_OfflineIndicator(self)
	end
end

function module:Update_PartyFrames(frame)
	local db = E.db.mui.unitframes

	if not frame.isChild then
		module:Configure_DeathIndicator(frame)
		module:Configure_OfflineIndicator(frame)
	end

	module:CreateHighlight(frame)
end
