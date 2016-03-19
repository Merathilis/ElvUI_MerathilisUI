local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

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