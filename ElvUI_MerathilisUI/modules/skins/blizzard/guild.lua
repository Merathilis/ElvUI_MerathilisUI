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

	_G["GuildFrame"]:Styling()

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