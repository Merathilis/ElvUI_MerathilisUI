local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule("Skins")

local _G = _G
local ipairs, pairs, type, unpack = ipairs, pairs, type, unpack

local IsAddOnLoaded = IsAddOnLoaded
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("character", "character") then
		return
	end

	-- _G.GearManagerDialogPopup:Styling()
end

S:AddCallback("PaperDollFrame", LoadSkin)
