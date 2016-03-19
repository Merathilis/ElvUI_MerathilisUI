local E, L, V, P, G = unpack(ElvUI);
local MUF = E:GetModule('MuiUnits');
local UF = E:GetModule('UnitFrames');

function MUF:CombatIcon_PostUpdate(inCombat)
	local frame = self:GetParent()
	self:ClearAllPoints()
	self:SetTexture(MUF.CombatTextures[E.db['mui']['unitframes']['unit']['player']['combatico']['texture']])
	if E.db['mui']['unitframes']['unit']['player']['combatico']['texture'] == "DEFAULT" or E.db['mui']['unitframes']['unit']['player']['combatico']['texture'] == "SVUI" then self:SetTexCoord(.5, 1, 0, .49) end
	self:Size(E.db['mui']['unitframes']['unit']['player']['combatico']['size'])
	self:Point("CENTER", frame.Health, "CENTER", E.db['mui']['unitframes']['unit']['player']['combatico']['xoffset'], E.db['mui']['unitframes']['unit']['player']['combatico']['yoffset'])
	if not E.db['mui']['unitframes']['unit']['player']['combatico']['red'] then self:SetVertexColor(1, 1, 1) end
end
