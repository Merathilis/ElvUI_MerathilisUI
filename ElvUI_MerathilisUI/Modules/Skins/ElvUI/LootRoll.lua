local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local M = E:GetModule("Misc")

local _G = _G
local pairs = pairs
local tinsert = tinsert
local unpack = unpack

function module:ElvUI_SkinLootRollFrame(frame)
	if not frame or frame:IsForbidden() or frame.__MERSkin then
		return
	end

	frame.button.__MERPoint = frame.button.Point
	frame.button.Point = function(f, anchor, parent, point, x, y)
		if anchor == "RIGHT" and parent == frame and point == "LEFT" then
			f:__MERPoint(anchor, parent, point, x and x - 4, y)
		else
			f:__MERPoint(anchor, parent, point, x, y)
		end
	end

	local points = {}
	for i = 1, frame.button:GetNumPoints() do
		tinsert(points, { frame.button:GetPoint(i) })
	end

	if #points > 0 then
		frame.button:ClearAllPoints()
		for _, point in pairs(points) do
			frame.button:Point(unpack(point))
		end
	end

	self:CreateBackdropShadow(frame.button)
	self:CreateBackdropShadow(frame.status)

	frame.__MERSkin = true
end

function module:ElvUI_LootRoll()
	if not (E.private.general.lootRoll or E.private.mui.skins.shadow.enable) then
		return
	end

	self:SecureHook(M, "LootRoll_Create", function(_, index)
		self:ElvUI_SkinLootRollFrame(_G["ElvUI_LootRollFrame" .. index])
	end)

	for _, bar in pairs(M.RollBars) do
		self:ElvUI_SkinLootRollFrame(bar)
	end
end

module:AddCallback("ElvUI_LootRoll")
