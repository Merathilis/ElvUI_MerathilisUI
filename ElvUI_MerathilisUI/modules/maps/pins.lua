local E, L, V, P, G = unpack(ElvUI);
local MER = E:GetModule('MerathilisUI');

-- Cache global variables
-- Lua functions

-- WoW API / Variables

local pins  = {}
local focus = nil

local create = function(button, z)
	local width  = WorldMapDetailFrame:GetWidth()
	local height = WorldMapDetailFrame:GetHeight()
	local x, y = WorldMapDetailFrame:GetCenter()
	local cx, cy = GetCursorPosition()

	x = ((cx/WorldMapDetailFrame:GetEffectiveScale()) - (x - width/2))/width
	y = ((y + height/2) - (cy/WorldMapDetailFrame:GetEffectiveScale()))/height

	if x >= 0 and y >= 0 and x <= 1 and y <= 1 then
		local p = CreateFrame('Button', z..'pin'..'_'..x, button)
		p:SetWidth(32) p:SetHeight(32)
		p:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		p:SetPoint('CENTER', button, 'TOPLEFT', x*width + 8, -y*height + 8)
		p:SetScript('OnClick', function()
			if arg1 == 'RightButton' then
				focus = p
				-- StaticPopup_Show('MAP_PIN_NOTE')
			else
				p:Hide() p.disable = true p.note = nil
			end
		end)
		p:SetScript('OnEnter', function()
			GameTooltip:SetOwner(p, 'ANCHOR_RIGHT')
			GameTooltip:AddLine(format('Pin: %.0f / %.0f', x*100, y*100))
			if p.note and p.note ~= '' then GameTooltip:AddLine('note: '..p.note) end
			GameTooltip:Show()
		end)
		p:SetScript('OnLeave', function() GameTooltip:Hide() end)
		tinsert(pins, p)

		local path = UnitFactionGroup'player' == 'Alliance' and [[Interface\WorldStateFrame\AllianceFlag]] or [[Interface\WorldStateFrame\HordeFlag]]
		local t = p:CreateTexture(nil, 'BACKGROUND')
		t:SetTexture(path)
		t:SetAllPoints()
	end
end

WorldMapButton:HookScript('OnClick', function(button, mButton)
	if IsShiftKeyDown() then
		local z = GetMapInfo()
			create(button, z)
	end
end)

hooksecurefunc('WorldMapFrame_Update', function()
	local z = GetMapInfo()
	for _, v in pairs(pins) do
		if not v.disable then
			local name = v:GetName()
			if string.find(name, z) then v:Show()
			else v:Hide() end
		end
	end
end)