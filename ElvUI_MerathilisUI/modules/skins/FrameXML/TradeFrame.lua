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
local IsCharacterFriend = IsCharacterFriend
local IsGuildMember = IsGuildMember
local UnitGUID = UnitGUID
--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS: MAX_TRADE_ITEMS, FRIEND, GUILD

local function styleTradeFrame()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.trade ~= true or E.private.muiSkins.blizzard.trade ~= true then return end

	local TradeFrame = _G["TradeFrame"]
	TradeFrame.backdrop:Styling()

	TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
	TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

	local function reskinButton(bu)
		bu:SetNormalTexture("")
		bu:SetPushedTexture("")
		bu.icon:SetTexCoord(unpack(E.TexCoords))
		bu.IconBorder:SetAlpha(0)
		bu:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
	end

	for i = 1, MAX_TRADE_ITEMS do
		_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
		_G["TradePlayerItem"..i.."NameFrame"]:Hide()
		_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
		_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

		if _G["TradePlayerItem"..i.."ItemButton"].bg then _G["TradePlayerItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradePlayerItem"..i.."ItemButton"].bg then MERS:CreateGradient(_G["TradePlayerItem"..i.."ItemButton"].bg) end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then _G["TradeRecipientItem"..i.."ItemButton"].bg:SetTemplate("Transparent") end
		if _G["TradeRecipientItem"..i.."ItemButton"].bg then MERS:CreateGradient(_G["TradeRecipientItem"..i.."ItemButton"].bg) end

		reskinButton(_G["TradePlayerItem"..i.."ItemButton"])
		reskinButton(_G["TradeRecipientItem"..i.."ItemButton"])
	end

	-- Display text on the TradeFrame if unit is a known person
	local infoText = MER:CreateText(TradeFrame, "OVERLAY", 16, "")
	infoText:ClearAllPoints()
	infoText:SetPoint("TOP", _G["TradeFrameRecipientNameText"], "BOTTOM", 0, -5)

	hooksecurefunc("TradeFrame_Update", function()
		local r, g, b = MER:UnitColor("NPC")
		_G["TradeFrameRecipientNameText"]:SetTextColor(r, g, b)

		local guid = UnitGUID("NPC")
		if not guid then return end
		local text = "|cffff0000"..L["Stranger"]

		if BNGetGameAccountInfoByGUID(guid) or IsCharacterFriend(guid) then
			text = "|cffffff00"..FRIEND
		elseif IsGuildMember(guid) then
			text = "|cff00ff00"..GUILD
		end

		infoText:SetText(text)
	end)
end

S:AddCallback("mUITradeFrame", styleTradeFrame)
