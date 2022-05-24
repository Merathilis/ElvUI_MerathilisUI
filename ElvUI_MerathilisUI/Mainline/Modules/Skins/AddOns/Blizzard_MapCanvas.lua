local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins

local _G = _G

local C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
local hooksecurefunc = hooksecurefunc

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

function module:Blizzard_MapCanvas()
	if E.private.skins.blizzard.enable ~= true then return end

	hooksecurefunc(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles", MapCanvasDetailLayerMixin_RefreshDetailTiles)
end

module:AddCallbackForAddon("Blizzard_MapCanvas")
