local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
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

	if _G.GossipFrameInset then
		_G.GossipFrameInset:Hide() -- Parchment
	end

	if GossipFrame.Background then
		GossipFrame.Background:Hide()
	end

	_G.QuestFont:SetTextColor(1, 1, 1)

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

	MER.NPC:Register(GossipFrame)
end

S:AddCallback("GossipFrame", LoadSkin)
