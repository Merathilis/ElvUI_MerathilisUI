local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local unpack = unpack

local hooksecurefunc = hooksecurefunc
local C_BattleNet_GetGameAccountInfoByGUID = C_BattleNet.GetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local IsGuildMember = IsGuildMember
local UnitGUID = UnitGUID

local function ReskinButton(bu)
	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu.icon:SetTexCoord(unpack(E.TexCoords))
	bu.IconBorder:SetAlpha(0)
	bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
end

function module:TradeFrame()
	if not module:CheckDB("trade", "trade") then
		return
	end

	local TradeFrame = _G.TradeFrame

	_G.TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	_G.TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	for i = 1, _G.MAX_TRADE_ITEMS do
		_G["TradePlayerItem" .. i .. "SlotTexture"]:Hide()
		_G["TradePlayerItem" .. i .. "NameFrame"]:Hide()
		_G["TradeRecipientItem" .. i .. "SlotTexture"]:Hide()
		_G["TradeRecipientItem" .. i .. "NameFrame"]:Hide()

		if _G["TradePlayerItem" .. i .. "ItemButton"].bg then
			_G["TradePlayerItem" .. i .. "ItemButton"].bg:SetTemplate(
				"Transparent")
		end
		if _G["TradePlayerItem" .. i .. "ItemButton"].bg then
			module:CreateGradient(_G
				["TradePlayerItem" .. i .. "ItemButton"].bg)
		end
		if _G["TradeRecipientItem" .. i .. "ItemButton"].bg then
			_G["TradeRecipientItem" .. i .. "ItemButton"].bg
				:SetTemplate("Transparent")
		end
		if _G["TradeRecipientItem" .. i .. "ItemButton"].bg then
			module:CreateGradient(_G
				["TradeRecipientItem" .. i .. "ItemButton"].bg)
		end

		ReskinButton(_G["TradePlayerItem" .. i .. "ItemButton"])
		ReskinButton(_G["TradeRecipientItem" .. i .. "ItemButton"])
	end

	-- Display text on the TradeFrame if unit is a known person
	TradeFrame.text = TradeFrame:CreateFontString(nil, 'OVERLAY')
	TradeFrame.text:FontTemplate(nil, 16, "SHADOWOUTLINE")
	TradeFrame.text:ClearAllPoints()
	TradeFrame.text:SetPoint("TOP", _G["TradeFrameRecipientNameText"], "BOTTOM", 0, -5)

	local function UpdateColor()
		local r, g, b = F.UnitColor("NPC")
		TradeFrameRecipientNameText:SetTextColor(r, g, b)

		local guid = UnitGUID("NPC")
		if not guid then return end

		local text = "|cffff0000" .. L["Stranger"]
		if C_BattleNet_GetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = "|cffffff00" .. _G.FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00ff00" .. _G.GUILD
		end
		TradeFrame.text:SetText(text)
	end
	hooksecurefunc("TradeFrame_Update", UpdateColor)
end

module:AddCallback("TradeFrame")
