local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

-- Cache global variables
-- GLOBALS: hooksecurefunc
local _G = _G

MUF.CombatTextures = {
	["DEFAULT"] = [[Interface\CharacterFrame\UI-StateIcon]],
	["SVUI"] = [[Interface\AddOns\ElvUI_MerathilisUI\media\textures\SVUI-StateIcon]],
}

function MUF:CombatIcon_PostUpdate(inCombat)
	local frame = self:GetParent()
	self:ClearAllPoints()
	self:SetTexture(MUF.CombatTextures[E.db['mui']['unitframes']['unit']['player']['combatico']['texture']])
	if E.db['mui']['unitframes']['unit']['player']['combatico']['texture'] == "DEFAULT" or E.db['mui']['unitframes']['unit']['player']['combatico']['texture'] == "SVUI" then self:SetTexCoord(.5, 1, 0, .49) end
	self:Size(E.db['mui']['unitframes']['unit']['player']['combatico']['size'])
	self:Point("CENTER", frame.Health, "CENTER", E.db['mui']['unitframes']['unit']['player']['combatico']['xoffset'], E.db['mui']['unitframes']['unit']['player']['combatico']['yoffset'])
	if not E.db['mui']['unitframes']['unit']['player']['combatico']['red'] then self:SetVertexColor(1, 1, 1) end
end

function MUF:UpdateRested(frame)
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
	_G["ElvUF_Player"].Combat.PostUpdate = MUF.CombatIcon_PostUpdate
	hooksecurefunc(UF, "Configure_RestingIndicator", MUF.UpdateRested)
end