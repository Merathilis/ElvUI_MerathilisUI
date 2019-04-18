local MER, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule("Skins")

--Cache global variables
local _G = _G
local select = select
--WoW API / Variables
local CreateFrame = CreateFrame
local GetCVar = GetCVar
local GetGuildLogoInfo = GetGuildLogoInfo
local SetSmallGuildTabardTextures = SetSmallGuildTabardTextures
local GetGuildTradeSkillInfo = GetGuildTradeSkillInfo
local hooksecurefunc = hooksecurefunc
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local function styleGuild()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.guild ~= true or E.private.muiSkins.blizzard.guild ~= true then return end

	_G.GuildFrame:Styling()

	-- Hide the blizzard layers
	hooksecurefunc("GuildRoster_UpdateTradeSkills", function()
		local buttons = _G.GuildRosterContainer.buttons
		for i = 1, #buttons do
			local index = _G.HybridScrollFrame_GetOffset(_G.GuildRosterContainer) + i
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

	-- Font width fix
	local function updateLevelString(view)
		if view == "playerStatus" or view == "reputation" or view == "achievement" then
			local buttons = _G.GuildRosterContainer.buttons
			for i = 1, #buttons do
				local str = _G["GuildRosterContainerButton"..i.."String1"]
				str:SetWidth(32)
				str:SetJustifyH("LEFT")
			end
			if view == "achievement" then
				for i = 1, #buttons do
					local str = _G["GuildRosterContainerButton"..i.."BarLabel"]
					str:SetWidth(60)
					str:SetJustifyH("LEFT")
				end
			end
		end
	end

	local done
	_G.GuildRosterContainer:HookScript("OnShow", function()
		if not done then
			updateLevelString(GetCVar("guildRosterView"))
			done = true
		end
	end)
	hooksecurefunc("GuildRoster_SetView", updateLevelString)
end

S:AddCallbackForAddon("Blizzard_GuildUI", "mUIGuild", styleGuild)
