local MER, W, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

if not IsAddOnLoaded("ElvUI_WindTools") then
	return
end

function module:LoadWindToolsProfile()
	local db = E.db.WT
	local private = E.private.WT
end

function module:ApplyWindToolsProfile()
	module:Wrap("Applying WindTools Profile ...", function()
		-- Apply Fonts
		self:LoadWindToolsProfile()

		FCT:UpdateUnitFrames()
		FCT:UpdateNamePlates()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			module:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "ElvUI_WindTools")
end
