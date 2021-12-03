local MER, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Emotes')
local CH = E:GetModule("Chat")

-- Cache global variables
-- Lua functions
local _G = _G
local pairs = pairs
local format = string.format
local gmatch, gsub = gmatch, gsub
local tinsert = table.insert
local strmatch, strtrim = strmatch, strtrim
-- WoW API / Variable
local CreateFrame = CreateFrame
local ChatEdit_ActivateChat = ChatEdit_ActivateChat
local ChatEdit_ChooseBoxForSend = ChatEdit_ChooseBoxForSend
local C_Club_GetMessageInfo = C_Club.GetMessageInfo
local InCombatLockdown = InCombatLockdown
local UISpecialFrames = UISpecialFrames
-- GLOBALS:

local ChatEmote = {}
module.ChatEmote = ChatEmote

ChatEmote.Config = {
	iconSize = 24,
	enableEmoteInput = true,
}

local customEmoteStartIndex = 9

local emotes = {
	-- RaidTarget
	{"{rt1}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
	{"{rt2}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
	{"{rt3}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
	{"{rt4}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
	{"{rt5}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
	{"{rt6}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
	{"{rt7}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
	{"{rt8}", [=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},

	-- ElvUI's emotes
	{":angry:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Angry]=]},
	{":blush:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Blush]=]},
	{":broken_heart:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\BrokenHeart]=]},
	{":call_me:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\CallMe]=]},
	{":cry:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Cry]=]},
	{":facepalm:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Facepalm]=]},
	{":grin:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Grin]=]},
	{":heart:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Heart]=]},
	{":heart_eyes:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\HeartEyes]=]},
	{":joy:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Joy]=]},
	{":kappa:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Kappa]=]},
	{":meaw:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Meaw]=]},
	{":middle_finger:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\MiddleFinger]=]},
	{":murloc:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Murloc]=]},
	{":ok_hand:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\OkHand]=]},
	{":open_mouth:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\OpenMouth]=]},
	{":poop:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Poop]=]},
	{":rage:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Rage]=]},
	{":sadkitty:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\SadKitty]=]},
	{":scream:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Scream]=]},
	{":scream_cat:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\ScreamCat]=]},
	{":slight_frown:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\SlightFrown]=]},
	{":smile:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Smile]=]},
	{":smirk:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Smirk]=]},
	{":sob:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Sob]=]},
	{":sunglasses:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Sunglasses]=]},
	{":thinking:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Thinking]=]},
	{":thumbs_up:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\ThumbsUp]=]},
	{":semi_colon:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\SemiColon]=]},
	{":wink:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\Wink]=]},
	{":zzz:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\ZZZ]=]},
	{":stuck_out_tongue:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\StuckOutTongue]=]},
	{":stuck_out_tongue_closed_eyes:", [=[Interface\AddOns\ElvUI\Core\Media\ChatEmojis\StuckOutTongueClosedEyes]=]},

	-- My emots
	{":monkaomega:", [=[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\ChatEmojis\monkaomega]=]},
	{":salt:", [=[Interface\AddOns\ElvUI_MerathilisUI\Core\Media\Textures\ChatEmojis\salt]=]},
}
module.emotes = emotes

local ShowEmoteTableButton
local EmoteTableFrame
local text, texture

local function CreateEmoteTableFrame()
	EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", E.UIParent, "BackdropTemplate")
	EmoteTableFrame:CreateBackdrop("Transparent")
	EmoteTableFrame.backdrop:Styling()
	EmoteTableFrame:Width((ChatEmote.Config.iconSize + 2) * 12 + 4)
	EmoteTableFrame:Height((ChatEmote.Config.iconSize + 2) * 5 + 4)
	EmoteTableFrame:Point("BOTTOMLEFT", _G.LeftChatPanel, "TOPLEFT", 0, 5)
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, EmoteTableFrame:GetDebugName())

	local icon, row, col
	row = 1
	col = 1
	for i = 1, #emotes do
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d", i), EmoteTableFrame)
		icon:Width(ChatEmote.Config.iconSize)
		icon:Height(ChatEmote.Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil, "ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:Point("TOPLEFT", (col - 1) * (ChatEmote.Config.iconSize + 2) + 2, -(row - 1) * (ChatEmote.Config.iconSize + 2) - 2)
		icon:SetScript("OnMouseUp", ChatEmote.EmoteIconMouseUp)
		icon:EnableMouse(true)
		col = col + 1
		if (col > 12) then
			row = row + 1
			col = 1
		end
	end
end

function ChatEmote.ToggleEmoteTable()
	if (not EmoteTableFrame) then CreateEmoteTableFrame() end
	if (EmoteTableFrame:IsShown()) then
		EmoteTableFrame:Hide()
	else
		EmoteTableFrame:Show()
	end
end

function ChatEmote.EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(frame.text)
	end
	ChatEmote.ToggleEmoteTable()
end

function module:LoadChatEmote()
	function C_Club.GetMessageInfo(clubId, streamId, messageId)
		local message = C_Club_GetMessageInfo(clubId, streamId, messageId)
		message.content = CH:GetSmileyReplacementText(message.content)
		return message
	end

	function CH:InsertEmotions(msg)
		for k, v in pairs(emotes) do
			msg = gsub(msg, v[1], "|T" .. v[2] .. ":16|t")
		end

		for word in gmatch(msg, "%s-%S+%s*") do
			word = strtrim(word)
			local pattern = gsub(word, "([%(%)%.%%%+%-%*%?%[%^%$])", "%%%1")
			local emoji = CH.Smileys[pattern]
			if emoji and strmatch(msg, "[%s%p]-" .. pattern .. "[%s%p]*") then
				local base64 = E.Libs.Base64:Encode(word)
				msg = gsub(msg, "([%s%p]-)" .. pattern .. "([%s%p]*)", (base64 and ("%1|Helvmoji:%%" .. base64 .. "|h|cFFffffff|r|h") or "%1") .. emoji .. "%2")
			end
		end
		return msg
	end
end

function module:Initialize()
	if E.db.mui.chat.emotes ~= true or E.private.chat.enable ~= true then return end

	local Emote = self.ChatEmote
	local ChatEmote = CreateFrame("Button", "mUIEmote", _G.LeftChatPanel)
	ChatEmote:Point("RIGHT", _G.ElvUI_CopyChatButton1, "LEFT", 0, 0)
	ChatEmote:Size(12, 12)
	ChatEmote:SetScript("OnClick", function()
		if InCombatLockdown() then return end
		Emote.ToggleEmoteTable()
	end)

	ChatEmote:SetNormalTexture("Interface\\Addons\\ElvUI\\Core\\Media\\ChatEmojis\\Smile")
	ChatEmote:GetNormalTexture():SetDesaturated(true)
	ChatEmote:GetNormalTexture():SetAlpha(.45)

	ChatEmote:SetScript("OnEnter", function(self)
		_G.GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, 6)
		_G.GameTooltip:AddLine(L["Click to open Emoticon Frame"])
		_G.GameTooltip:Show()
		ChatEmote:SetNormalTexture("Interface\\Addons\\ElvUI\\Core\\Media\\ChatEmojis\\Scream")
		ChatEmote:GetNormalTexture():SetDesaturated(false)
		ChatEmote:GetNormalTexture():SetAlpha(1)
	end)

	ChatEmote:SetScript("OnLeave", function(self)
		_G.GameTooltip:Hide()
		ChatEmote:SetNormalTexture("Interface\\Addons\\ElvUI\\Core\\Media\\ChatEmojis\\Smile")
		ChatEmote:GetNormalTexture():SetDesaturated(true)
		ChatEmote:GetNormalTexture():SetAlpha(.45)
	end)

	self:LoadChatEmote()
end

MER:RegisterModule(module:GetName())
