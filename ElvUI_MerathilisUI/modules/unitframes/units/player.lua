local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

-- Cache global variables
-- Lua functions
local _G = _G
-- WoW API / Variables

-- Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: hooksecurefunc

function MUF:Construct_PlayerFrame()

	self:ArrangePlayer()
end

function MUF:ArrangePlayer()
	local frame = _G["ElvUF_Player"]

	-- RestIcon
	MUF:Configure_RestingIndicator(frame)

	frame:UpdateAllElements("MerathilisUI_UpdateAllElements")
end

function MUF:Configure_RestingIndicator(frame)
	local rIcon = frame.Resting
	local db = frame.db
	local Mdb = E.db['mui']['unitframes']['unit']['player']['rested']
	if db.restIcon then
		rIcon:ClearAllPoints()
		if frame.ORIENTATION == "RIGHT" then
			rIcon:Point("CENTER", frame.Health, "TOPLEFT", -3 + Mdb.xoffset, 6 + Mdb.yoffset)
		else
			if frame.USE_PORTRAIT and not frame.USE_PORTRAIT_OVERLAY then
				rIcon:Point("CENTER", frame.Portrait, "TOPLEFT", -3 + Mdb.xoffset, 6 + Mdb.yoffset)
			else
				rIcon:Point("CENTER", frame.Health, "TOPLEFT", -3 + Mdb.xoffset, 6 + Mdb.yoffset)
			end
		end
		rIcon:Size(Mdb.size)
		if Mdb.texture == "DEFAULT" or Mdb.texture == "SVUI" then
			rIcon:SetTexture(MUF.CombatTextures[Mdb.texture])
			rIcon:SetTexCoord(0, .5, 0, .421875)
		end
	end
end

function MUF:InitPlayer()
	if not E.db.unitframe.units.player.enable then return end
	self:Construct_PlayerFrame()
	hooksecurefunc(UF, "Configure_RestingIndicator", MUF.Configure_RestingIndicator)
end