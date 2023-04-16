local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function updateMinimizeButton(self)
	_G.WatchFrameCollapseExpandButton.__texture:DoCollapse(self.collapsed)
	_G.WatchFrame.header:SetShown(not self.collapsed)
end

local function reskinMinimizeButton(button)
	module:ReskinCollapse(button)
	button:GetNormalTexture():SetAlpha(0)
	button:GetPushedTexture():SetAlpha(0)
	button.__texture:DoCollapse(false)
end

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
	end

	reskinMinimizeButton(_G.WatchFrameCollapseExpandButton)
	hooksecurefunc("WatchFrame_Collapse", updateMinimizeButton)
	hooksecurefunc("WatchFrame_Expand", updateMinimizeButton)

	local header = CreateFrame("Frame", nil, _G.WatchFrameHeader)
	header:SetSize(1, 1)
	header:SetPoint("TOPLEFT")
	_G.WatchFrame.header = header

	local bg = header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
	bg:SetTexCoord(0, .66, 0, .31)
	bg:SetVertexColor(F.r, F.g, F.b, .8)
	bg:SetPoint("TOPLEFT", -25, 5)
	bg:SetSize(250, 30)
end

S:AddCallback("QuestFrame", LoadSkin)
