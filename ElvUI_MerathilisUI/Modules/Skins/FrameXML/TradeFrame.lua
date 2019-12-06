local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

-- Cache global variables
-- Lua functions
local _G = _G
local unpack = unpack
-- WoW API / Variables
local hooksecurefunc = hooksecurefunc
local BNGetGameAccountInfoByGUID = BNGetGameAccountInfoByGUID
local C_FriendList_IsFriend = C_FriendList.IsFriend
local IsGuildMember = IsGuildMember
local UnitGUID = UnitGUID
-- GLOBALS:

local function ReskinButton(bu)
	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu.icon:SetTexCoord(unpack(E.TexCoords))
	bu.IconBorder:SetAlpha(0)
	bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trade ~= true or E.private.muiSkins.blizzard.trade ~= true then return end

	local TradeFrame = _G.TradeFrame
	TradeFrame.backdrop:Styling()

	_G.TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	_G.TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", _G.TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	for i = 1, _G.MAX_TRADE_ITEMS do
		_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
		_G["TradePlayerItem"..i.."NameFrame"]:Hide()
		_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
		_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

		if _G["TradePlayerItem"..i.."ItemButton"].bg then _G["TradePlayerItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradePlayerItem"..i.."ItemButton"].bg then MERS:CreateGradient(_G["TradePlayerItem"..i.."ItemButton"].bg) end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then _G["TradeRecipientItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then MERS:CreateGradient(_G["TradeRecipientItem"..i.."ItemButton"].bg) end

		ReskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		ReskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end

	-- Display text on the TradeFrame if unit is a known person
	local infoText = MER:CreateText(TradeFrame, "OVERLAY", 16, "")
	infoText:ClearAllPoints()
	infoText:SetPoint("TOP", _G["TradeFrameRecipientNameText"], "BOTTOM", 0, -5)

	local function UpdateColor()
		local r, g, b = MER:UnitColor("NPC")
		_G["TradeFrameRecipientNameText"]:SetTextColor(r, g, b)

		local guid = UnitGUID("NPC")
		if not guid then return end
		local text = "|cffff0000"..L["Stranger"]

		if BNGetGameAccountInfoByGUID(guid) or C_FriendList_IsFriend(guid) then
			text = "|cffffff00".._G.FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00ff00".._G.GUILD
		end
		infoText:SetText(text)
	end

	hooksecurefunc("TradeFrame_Update", UpdateColor)
end

S:AddCallback("mUITradeFrame", LoadSkin)
