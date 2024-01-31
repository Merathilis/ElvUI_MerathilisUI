local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')

local _G = _G

local NUM_SLOTS_PER_GUILDBANK_GROUP = 14
local NUM_GUILDBANK_COLUMNS = 7

function module:Blizzard_GuildBankUI()
	if not module:CheckDB("gbank", "gbank") then
		return
	end

	module:CreateShadow(_G.GuildBankFrame)
	module:CreateShadow(_G.GuildBankPopupFrame)

	for i = 1, 4 do
		local tab = _G["GuildBankFrameTab" .. i]
		module:ReskinTab(tab)

		if i ~= 1 then
			tab:SetPoint("LEFT", _G["GuildBankFrameTab" .. i - 1], "RIGHT", -15, 0)
		end
	end

	for i = 1, 8 do
		local tab = _G["GuildBankTab" .. i]
		if tab then
			module:CreateShadow(tab.Button)
		end
	end

	if _G.GuildBankFrame.inset then
		_G.GuildBankFrame.inset:Hide()
	end

	for i = 1, NUM_GUILDBANK_COLUMNS do
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			local button = _G["GuildBankColumn" .. i .. "Button" .. j]
			if button then
				button:SetTemplate("Transparent")
				module:CreateGradient(button)
			end
		end
	end
end

module:AddCallbackForAddon("Blizzard_GuildBankUI")
