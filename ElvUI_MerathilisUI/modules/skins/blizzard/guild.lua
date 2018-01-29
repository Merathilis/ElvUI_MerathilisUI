local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local select = select
--WoW API / Variables
local CreateFrame = CreateFrame
local GetGuildLogoInfo = GetGuildLogoInfo
local SetSmallGuildTabardTextures = SetSmallGuildTabardTextures
local GetGuildTradeSkillInfo = GetGuildTradeSkillInfo

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGuild()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true or E.private.muiSkins.blizzard.guild ~= true then return end
	local emblem = select(10, GetGuildLogoInfo())

	_G["GuildFrame"]:Styling()

	local guildBanner = CreateFrame("Frame", nil, GuildFrame)
	guildBanner:SetInside()
	guildBanner:SetFrameLevel(10)

	guildBanner.bg = guildBanner:CreateTexture(nil, "BACKGROUND")
	guildBanner.bg:Size(36, 46)
	guildBanner.bg:SetTexCoord(.00781250, .32812500, .01562500, .84375000)
	guildBanner.bg:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	guildBanner.bg:Point("TOPLEFT", GuildFrame, "TOPLEFT", 5, -5)

	guildBanner.border = guildBanner:CreateTexture(nil, "ARTWORK")
	guildBanner.border:Size(36, 46)
	guildBanner.border:SetTexCoord(.34375000, .66406250, .01562500, .84375000)
	guildBanner.border:SetTexture("Interface\\GuildFrame\\GuildDifficulty")
	guildBanner.border:Point("CENTER", guildBanner.bg)

	guildBanner.emblem = guildBanner:CreateTexture(nil, "OVERLAY")
	guildBanner.emblem:Size(18)
	guildBanner.emblem:SetTexture("Interface\\GuildFrame\\GuildEmblems_01")
	guildBanner.emblem:Point("CENTER", guildBanner.bg, 0, 2)

	if(emblem) then
		SetSmallGuildTabardTextures("player", guildBanner.emblem, guildBanner.bg, guildBanner.border)
	end

	-- Hide the blizzard layers
	hooksecurefunc("GuildRoster_UpdateTradeSkills", function()
		local buttons = _G["GuildRosterContainer"].buttons
		for i = 1, #buttons do
			local index = HybridScrollFrame_GetOffset(GuildRosterContainer) + i
			local str1 = _G["GuildRosterContainerButton"..i.."String1"]
			local str3 = _G["GuildRosterContainerButton"..i.."String3"]
			local header = _G["GuildRosterContainerButton"..i.."HeaderButton"]
			if header then
				local _, _, _, headerName = GetGuildTradeSkillInfo(index)
				if headerName then
					str1:Hide()
					str3:Hide()
				else
					str1:Show()
					str3:Show()
				end
			end
		end
	end)
end

S:AddCallbackForAddon("Blizzard_GuildUI", "mUIGuild", styleGuild)