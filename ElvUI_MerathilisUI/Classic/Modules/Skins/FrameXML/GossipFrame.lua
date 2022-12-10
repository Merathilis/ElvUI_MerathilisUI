local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select
local strmatch = strmatch
local gsub = string.gsub

local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if not module:CheckDB("gossip", "gossip") then
		return
	end

	local GossipFrame = _G.GossipFrame
	if GossipFrame.backdrop then
		GossipFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(GossipFrame)

	_G.GossipGreetingScrollFrame:StripTextures()

	if _G.GossipFrameInset then
		_G.GossipFrameInset:Hide() -- Parchment
	end

	if GossipFrame.Background then
		GossipFrame.Background:Hide()
	end

	if _G.GossipGreetingScrollFrame.backdrop then
		_G.GossipGreetingScrollFrame.backdrop:Hide()
	end

	_G.QuestFont:SetTextColor(1, 1, 1)
	_G.GossipGreetingText:SetTextColor(1, 1, 1)

	hooksecurefunc('GossipFrameUpdate', function()
		for i = 1, _G.NUMGOSSIPBUTTONS do
			local button = _G['GossipTitleButton'..i]
			local icon = _G['GossipTitleButton'..i..'GossipIcon']
			local text = button:GetFontString()

			if text and text:GetText() then
				local textString = gsub(text:GetText(), '|c[Ff][Ff]%x%x%x%x%x%x(.+)|r', '%1')

				button:SetText(textString)
				text:SetTextColor(1, 1, 1)

				if button.type == 'Available' or button.type == 'Active' then
					if button.type == 'Active' then
						icon:SetDesaturation(1)
						text:SetTextColor(.6, .6, .6)
					else
						icon:SetDesaturation(0)
						text:SetTextColor(1, .8, .1)
					end

					local numEntries = GetNumQuestLogEntries()
					for k = 1, numEntries, 1 do
						local questLogTitleText, _, _, _, _, isComplete, _, questId = GetQuestLogTitle(k)
						if strmatch(questLogTitleText, textString) then
							if (isComplete == 1 or IsQuestComplete(questId)) then
								icon:SetDesaturation(0)
								button:GetFontString():SetTextColor(1, .8, .1)
								break
							end
						end
					end
				end
			end
		end
	end)

	for i = 1, 4 do
		local notch = _G["NPCFriendshipStatusBarNotch"..i]
		if notch then
			notch:SetColorTexture(0, 0, 0)
			notch:SetSize(E.mult, 16)
		end
	end
	select(7, _G.NPCFriendshipStatusBar:GetRegions()):Hide()

	_G.NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
	module:CreateBDFrame(_G.NPCFriendshipStatusBar, .25)

	if not IsAddOnLoaded("ElvUI_SLE") then
		MER.NPC:Register(GossipFrame)
		hooksecurefunc("GossipTitleButton_OnClick", function() MER.NPC:PlayerTalksFirst() end)
	end
end

S:AddCallback("GossipFrame", LoadSkin)
