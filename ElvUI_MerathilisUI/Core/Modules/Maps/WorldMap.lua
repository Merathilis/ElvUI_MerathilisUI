local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_WorldMap')

local _G = _G
local ceil = ceil
local collectgarbage = collectgarbage
local gsub = gsub
local ipairs = ipairs
local mod = mod
local pairs = pairs
local strsplit = strsplit
local tinsert = tinsert
local tonumber = tonumber

local IsAddOnLoaded = IsAddOnLoaded
local TexturePool_HideAndClearAnchors = TexturePool_HideAndClearAnchors

local C_MapExplorationInfo_GetExploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures
local C_Map_GetMapArtID = C_Map.GetMapArtID
local C_Map_GetMapArtLayers = C_Map.GetMapArtLayers
local MapCanvasScrollControllerMixin_GetCursorPosition = MapCanvasScrollControllerMixin.GetCursorPosition

local overlayTextures = {}

function module:HandleMap(map, fullUpdate)
	overlayTextures = {}
	local mapID = _G.WorldMapFrame.mapID
	if not mapID then
		return
	end

	local artID = C_Map_GetMapArtID(mapID)
	if not artID or not module.RevealDatabase[artID] then
		return
	end
	local zone = module.RevealDatabase[artID]

	local TileExists = {}
	local exploredMapTextures = C_MapExplorationInfo_GetExploredMapTextures(mapID)
	if exploredMapTextures then
		for i, tex in ipairs(exploredMapTextures) do
			local key = tex.textureWidth .. ":" .. tex.textureHeight .. ":" .. tex.offsetX .. ":" .. tex.offsetY
			TileExists[key] = true
		end
	end

	map.layerIndex = map:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
	local layers = C_Map_GetMapArtLayers(mapID)
	local layerInfo = layers and layers[map.layerIndex]
	if not layerInfo then
		return
	end
	local TILE_SIZE_WIDTH = layerInfo.tileWidth
	local TILE_SIZE_HEIGHT = layerInfo.tileHeight

	for key, files in pairs(zone) do
		if not TileExists[key] then
			local width, height, offsetX, offsetY = strsplit(":", key)
			local fileDataIDs = {strsplit(",", files)}
			local numTexturesWide = ceil(width / TILE_SIZE_WIDTH)
			local numTexturesTall = ceil(height / TILE_SIZE_HEIGHT)
			local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
			for j = 1, numTexturesTall do
				if (j < numTexturesTall) then
					texturePixelHeight = TILE_SIZE_HEIGHT
					textureFileHeight = TILE_SIZE_HEIGHT
				else
					texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
					if (texturePixelHeight == 0) then
						texturePixelHeight = TILE_SIZE_HEIGHT
					end
					textureFileHeight = 16
					while (textureFileHeight < texturePixelHeight) do
						textureFileHeight = textureFileHeight * 2
					end
				end
				for k = 1, numTexturesWide do
					local texture = map.overlayTexturePool:Acquire()
					if (k < numTexturesWide) then
						texturePixelWidth = TILE_SIZE_WIDTH
						textureFileWidth = TILE_SIZE_WIDTH
					else
						texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
						if (texturePixelWidth == 0) then
							texturePixelWidth = TILE_SIZE_WIDTH
						end
						textureFileWidth = 16
						while (textureFileWidth < texturePixelWidth) do
							textureFileWidth = textureFileWidth * 2
						end
					end
					texture:Size(texturePixelWidth, texturePixelHeight)
					texture:SetTexCoord(0, texturePixelWidth / textureFileWidth, 0, texturePixelHeight / textureFileHeight)
					texture:Point("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k - 1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
					texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")
					texture:SetDrawLayer("ARTWORK", -1)
					texture:Show()
					if fullUpdate then
						map.textureLoadGroup:AddTexture(texture)
					end

					if module.db and module.db.reveal.enable and module.db.reveal.useColor then
						texture:SetVertexColor(module.db.reveal.color.r, module.db.reveal.color.g, module.db.reveal.color.b, module.db.reveal.color.a)
					end

					tinsert(overlayTextures, texture)
				end
			end
		end
	end
end

-- from Leatrix_Maps
local function TexturePool_ResetVertexColor(pool, texture)
	texture:SetVertexColor(1, 1, 1)
	texture:SetAlpha(1)
	return TexturePool_HideAndClearAnchors(pool, texture)
end

function module:Reveal()
	if not self.db.reveal.enable then
		return
	end

	-- Exclude some areas; Thanks Leatrix_Maps
	if E.myfraction == "Alliance" then
		module.RevealDatabase[556]["223:279:194:0"] = gsub(module.RevealDatabase[556]["223:279:194:0"], "1037663", "")
	elseif E.myfraction == "Horde" then
		module.RevealDatabase[542]["267:257:336:327"] = gsub(module.RevealDatabase[542]["267:257:336:327"], "1003342", "")
	end

	module.RevealDatabase[521] = nil -- Throne of Thunder
	module.RevealDatabase[1176] = nil -- The Dredge (Darkshore)
	module.RevealDatabase[67]["453:340:0:0"] = nil -- Veiled Sea (Darkshore)

	for pin in _G.WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		self:SecureHook(pin, "RefreshOverlays", "HandleMap")
		pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
	end
end

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

	if IsAddOnLoaded("Mapster") then
		self.StopRunning = "Mapster"
		return
	end

	self.db = E.db.mui.maps.worldMap

	if not self.db or not self.db.enable then
		return
	end

	if E.Retail then
		_G.QuestMapFrame:SetScript("OnHide", nil) -- fix potential toggle taint with HandyNotes or any other WQ AddOn

		self:Scale()
	end

	self:Reveal()
end

MER:RegisterModule(module:GetName())
