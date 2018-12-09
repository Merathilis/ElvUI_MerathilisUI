local MER, E, L, V, P, G = unpack(select(2, ...))
local MERC = MER:GetModule("muiChat")

--Cache global variables
--Lua Variables
local _G = _G
local pairs, unpack = pairs, unpack
local tinsert = table.insert
--WoW API / Variables
local CreateFrame = CreateFrame
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

function MERC:ChatBar()
	if E.private.chat.enable ~= true or E.db.mui.chat.chatBar ~= true then return end

	local chatFrame = SELECTED_DOCK_FRAME
	local editBox = chatFrame.editBox
	local width, height, padding, buttonList = 52, 6, 5, {}

	local ChatbarHolder = CreateFrame("Frame", nil, E.UIParent)
	ChatbarHolder:CreatePanel("Invisible", _G["LeftChatPanel"]:GetWidth(), height, "BOTTOM", _G["LeftChatPanel"], 2, -2)
	ChatbarHolder:SetFrameStrata("MEDIUM")

	local function AddButton(r, g, b, text, func)
		local bu = CreateFrame("Button", nil, ChatbarHolder, "SecureActionButtonTemplate")
		bu:SetSize(width, height)

		bu.Icon = bu:CreateTexture(nil, "ARTWORK")
		bu.Icon:SetAllPoints()
		bu.Icon:SetTexCoord(unpack(E.TexCoords))
		bu.Icon:SetTexture(E["media"].normTex)
		bu.Icon:SetVertexColor(r, g, b)

		bu:SetHitRectInsets(0, 0, -8, -8)
		bu:RegisterForClicks("AnyUp")

		if text then MER:AddTooltip(bu, "ANCHOR_TOP", E:RGBToHex(r, g, b)..text) end
		if func then bu:SetScript("OnClick", func) end

		tinsert(buttonList, bu)
		return bu
	end

	-- Create Chatbars
	local buttonInfo = {
		{1, 1, 1, SAY.."/"..YELL, function(_, btn)
			if btn == "RightButton" then
				ChatFrame_OpenChat("/y ", chatFrame)
			else
				ChatFrame_OpenChat("/s ", chatFrame)
			end
		end},

		{1, .5, 1, WHISPER, function(_, btn)
			if btn == "RightButton" then
				ChatFrame_ReplyTell(chatFrame)
				if not editBox:IsVisible() or editBox:GetAttribute("chatType") ~= "WHISPER" then
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			else
				if UnitExists("target") and UnitName("target") and UnitIsPlayer("target") and GetDefaultLanguage("player") == GetDefaultLanguage("target") then
					local name = GetUnitName("target", true)
					ChatFrame_OpenChat("/w "..name.." ", chatFrame)
				else
					ChatFrame_OpenChat("/w ", chatFrame)
				end
			end
		end},

		{.65, .65, 1, PARTY, function()
			ChatFrame_OpenChat("/p ", chatFrame)
		end},

		{1, .5, 0, INSTANCE.."/"..RAID, function()
			if IsPartyLFG() then
				ChatFrame_OpenChat("/i ", chatFrame)
			else
				ChatFrame_OpenChat("/raid ", chatFrame)
			end
		end},

		{.25, 1, .25, GUILD.."/"..OFFICER, function(_, btn)
			if btn == "RightButton" and CanEditOfficerNote() then
				ChatFrame_OpenChat("/o ", chatFrame)
			else
				ChatFrame_OpenChat("/g ", chatFrame)
			end
		end},
	}

	for _, info in pairs(buttonInfo) do
		AddButton(unpack(info))
	end

	-- ROLL
	local roll = AddButton(.8, 1, .6, LOOT_ROLL)
	roll:SetAttribute("type", "macro")
	roll:SetAttribute("macrotext", "/roll")

	-- COMBATLOG
	local combat = AddButton(1, 1, 0, BINDING_NAME_TOGGLECOMBATLOG)
	combat:SetAttribute("type", "macro")
	combat:SetAttribute("macrotext", "/combatlog")

	-- Order Postions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i-1], "RIGHT", padding, 0)
		end
	end
end
