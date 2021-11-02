local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_WorldMap')

local _G = _G

local MapCanvasScrollControllerMixin_GetCursorPosition = MapCanvasScrollControllerMixin.GetCursorPosition

function module:Scale()
	if not self.db.scale.enable then
		return
	end

	_G.WorldMapFrame:SetClampedToScreen(true)
	_G.WorldMapFrame:SetScale(self.db.scale.size)

	_G.WorldMapFrame.ScrollContainer.GetCursorPosition = function(cursor)
		local x, y = MapCanvasScrollControllerMixin_GetCursorPosition(cursor)
		local scale = _G.WorldMapFrame:GetScale()
		return x / scale, y / scale
	end
end

function module:Initialize()
	if not E.private.general.worldMap then
		return
	end

	self.db = E.db.mui.maps.worldMap

	_G.QuestMapFrame:SetScript("OnHide", nil) -- fix potential toggle taint with HandyNotes or any other WQ AddOn

	self:Scale()
end

MER:RegisterModule(module:GetName())
