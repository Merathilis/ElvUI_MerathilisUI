local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local NUM_SLOTS_PER_GUILDBANK_GROUP = 14
local NUM_GUILDBANK_COLUMNS = 7

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gbank ~= true or E.private.muiSkins.blizzard.gbank ~= true then return end

	_G.GuildBankFrame:Styling()
	MER:CreateBackdropShadow(_G.GuildBankFrame)
	_G.GuildBankPopupFrame:Styling()
	MER:CreateBackdropShadow(_G.GuildBankPopupFrame)

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab"..i]

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab"..i-1], "RIGHT", -15, 0)
		end
	end

	if _G.GuildBankFrame.inset then
		_G.GuildBankFrame.inset:Hide()
	end

	for i = 1, NUM_GUILDBANK_COLUMNS do
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn"..i.."Button"..j]
			if button then
				button:CreateBackdrop("Transparent")
				MERS:CreateGradient(button)
			end
		end
	end
end

S:AddCallbackForAddon("Blizzard_GuildBankUI", "mUIGuildBank", LoadSkin)
