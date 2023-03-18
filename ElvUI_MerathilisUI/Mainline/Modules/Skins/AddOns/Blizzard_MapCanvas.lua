local MER, F, E, L, V, P, G = unpack((select(2, ...)))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
local hooksecurefunc = hooksecurefunc

local function MapCanvasDetailLayerMixin_RefreshDetailTiles(self)
	local layers = C_Map_GetMapArtLayers(self.mapID)
	local layerInfo = layers[self.layerIndex]

	for detailTile in self.detailTilePool:EnumerateActive() do
		if not detailTile.__MERSkin then
			detailTile:SetSize(layerInfo.tileWidth, layerInfo.tileHeight)
			detailTile.__MERSkin = true
		end
	end
end

local function LoadSkin()
	if not module:CheckDB("worldmap", "worldmap") then
		return
	end

	hooksecurefunc(_G.MapCanvasDetailLayerMixin, "RefreshDetailTiles", MapCanvasDetailLayerMixin_RefreshDetailTiles)
end

S:AddCallbackForAddon("Blizzard_MapCanvas", LoadSkin)
