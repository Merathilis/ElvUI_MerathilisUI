local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")
local MERS = MER:GetModule("muiSkins")

--Cache global variables
--Lua functions
local _G = _G
--WoW API / Variables
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gbank ~= true or E.private.muiSkins.blizzard.gbank ~= true then return end

	_G.GuildBankFrame:Styling()
	_G.GuildBankPopupFrame:Styling()

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	for i = 1, 8 do
		local button = _G["GuildBankTab"..i.."Button"]

		local a1, p, a2, x, y = button:GetPoint()
		button:SetPoint(a1, p, a2, x + E.mult, y)
	end

	if _G.GuildBankFrame.inset then
		_G.GuildBankFrame.inset:Hide()
	end

	for i = 1, _G.NUM_GUILDBANK_COLUMNS do
		for j = 1, _G.NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..j]
			if button then
				button:SetTemplate("Transparent")
				MERS:CreateGradient(button)
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_GuildBankUI", "mUIGuildBank", LoadSkin)
