local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
--WoW API / Variables
local C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function MapCanvasDetailLayerMixin_RefreshDetailTiles(self)
	local layers = C_Map_GetMapArtLayers(self.mapID)
	local layerInfo = layers[self.layerIndex]

	for detailTile in self.detailTilePool:EnumerateActive() do
		if not detailTile.isSkinned then
			detailTile:SetSize(layerInfo.tileWidth, layerInfo.tileHeight)
			detailTile.isSkinned = true
		end
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles", MapCanvasDetailLayerMixin_RefreshDetailTiles)
end

S:AddCallbackForAddon("Blizzard_MapCancas", "mUIMapCanvas", LoadSkin)
