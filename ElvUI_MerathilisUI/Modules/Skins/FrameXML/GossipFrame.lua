local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

-- Cache global variables
-- Lua functions
local _G = _G
local select, unpack = select, unpack
local gsub = string.gsub
-- WoW API / Variables
local C_Timer_After = C_Timer.After
local hooksecurefunc = hooksecurefunc
-- GLOBALS:

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true or E.private.muiSkins.blizzard.gossip ~= true then return; end

	local GossipFrame = _G.GossipFrame
	GossipFrame:Styling()

	_G.GossipGreetingScrollFrame:StripTextures()
	if _G.GossipGreetingScrollFrame.backdrop then
		_G.GossipGreetingScrollFrame.backdrop:Hide()
	end

	if not E.private.skins.parchmentRemoverEnable then
		_G.GossipGreetingScrollFrame.spellTex:SetTexture('') -- Remove Parchement
	end

	if GossipFrame.buttons and next(GossipFrame.buttons) then
		for _, button in ipairs(GossipFrame.buttons) do
			local str = button:GetFontString()
			if str then str:SetTextColor(1, 1, 1) end
		end
	end

	_G.GossipGreetingText:SetTextColor(1, 1, 1)

	hooksecurefunc("GossipFrameUpdate", function()
		if GossipFrame.buttons and next(GossipFrame.buttons) then
			for _, button in ipairs(GossipFrame.buttons) do
				local str = button:GetFontString()
				if str then
					-- 9.0 Shadowland, Azilroka look at this please-
					-- the below shit seems not to work so using: str:SetTextColor(1, 1, 1) for now.
					str:SetTextColor(1, 1, 1)
					local text = str:GetText()
					if text and strfind(text, '|cff000000') then
						str:SetText(gsub(text, '|cff000000', '|cffffe519'))
					end
				end
			end
		end
	end)

	_G.NPCFriendshipStatusBar:GetRegions():Hide()
	_G.NPCFriendshipStatusBarNotch1:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch1:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch2:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch2:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch3:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch3:SetSize(1, 16)
	_G.NPCFriendshipStatusBarNotch4:SetColorTexture(0, 0, 0)
	_G.NPCFriendshipStatusBarNotch4:SetSize(1, 16)
	select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

	_G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	MERS:CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

	MER.NPC:Register(GossipFrame)
	hooksecurefunc("GossipTitleButton_OnClick", function() MER.NPC:PlayerTalksFirst() end)
end

S:AddCallback("mUIGossip", LoadSkin)
