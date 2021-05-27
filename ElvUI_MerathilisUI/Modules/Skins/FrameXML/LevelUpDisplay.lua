local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G

local IsInJailersTower = IsInJailersTower

local r, g, b = unpack(E.media.rgbvaluecolor)

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.muiSkins.blizzard.levelUp ~= true or IsInJailersTower() then return end

	--/script LevelUpDisplay:Show()
	local frame = _G.LevelUpDisplay

	_G.LevelUpDisplayGLine:Kill()
	_G.LevelUpDisplayGLine2:Kill()

	frame.StatusLine = CreateFrame("StatusBar", nil, frame)
	frame.StatusLine:Size(418, 2)
	frame.StatusLine:Point("TOP", frame, 0, -5)
	frame.StatusLine:SetStatusBarTexture(E.Media.Textures.Highlight)
	frame.StatusLine:SetStatusBarColor(r, g, b, 0.7)

	frame.StatusLine2 = CreateFrame("StatusBar", nil, frame)
	frame.StatusLine2:Size(418, 2)
	frame.StatusLine2:Point("BOTTOM", frame, 0, -3)
	frame.StatusLine2:SetStatusBarTexture(E.Media.Textures.Highlight)
	frame.StatusLine2:SetStatusBarColor(r, g, b, 0.7)
end

S:AddCallback("mUILevelUp", LoadSkin)
