local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Nameplates")
local NP = E:GetModule("NamePlates")

local hooksecurefunc = hooksecurefunc
local pairs = pairs

-- The oUF element itself lives in Modules/UnitFrames/Elements/FactionIndicator.lua

-- isStyling: called from StylePlate, where oUF has not set up the plate's element
-- bookkeeping yet; oUF enables every element with an existing widget right afterwards
function module:Configure_FactionIndicator(nameplate, isStyling)
	if not nameplate or nameplate == NP.TestFrame then
		return
	end

	local db = E.db.mui.nameplates.factionIndicator
	if not (db and db.enable) then
		if nameplate.MER_FactionIndicator and nameplate:IsElementEnabled("MER_FactionIndicator") then
			nameplate:DisableElement("MER_FactionIndicator")
		end
		return
	end

	local element = nameplate.MER_FactionIndicator
	if not element then
		element = nameplate.RaisedElement:CreateTexture(nil, "OVERLAY", nil, 2)
		element:Hide()
		nameplate.MER_FactionIndicator = element
	end

	element.style = db.style
	element:Size(db.size)
	element:ClearAllPoints()
	element:Point(E.InversePoints[db.position], nameplate, db.position, db.xOffset, db.yOffset)

	if isStyling then
		return
	end

	if not nameplate:IsElementEnabled("MER_FactionIndicator") then
		nameplate:EnableElement("MER_FactionIndicator")
	end

	-- A plate without a unit gets its update through UpdateAllElements once it is shown
	if nameplate.__unit then
		element:ForceUpdate()
	end
end

function module:UpdateFactionIndicators()
	if not NP.Plates then
		return
	end

	for nameplate in pairs(NP.Plates) do
		module:Configure_FactionIndicator(nameplate)
	end
end

function module:FactionIndicator()
	hooksecurefunc(NP, "StylePlate", function(_, nameplate)
		module:Configure_FactionIndicator(nameplate, true)
	end)

	-- Plates that already existed before the hook
	module:UpdateFactionIndicators()
end
