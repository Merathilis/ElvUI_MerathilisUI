local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc

local function CreateHeaderPanels()
	local HeaderBar = CreateFrame("StatusBar", nil, _G.QuestWatchFrame)
	local HeaderText = HeaderBar:CreateFontString(nil, "OVERLAY")

	HeaderBar:SetFrameStrata("LOW")
	HeaderBar:SetPoint("TOPLEFT", _G.QuestWatchFrame, 0, -4)
	HeaderBar:SetSize(160, 2)
	module:SkinPanel(HeaderBar)

	HeaderText:SetFontObject(_G.GameFontNormal)
	HeaderText:Point("LEFT", HeaderBar, "LEFT", -2, 14)
	HeaderText:SetText(_G.CURRENT_QUESTS)

	--Change font of watched quests
	for i = 1, 30 do
		local Line = _G["QuestWatchLine"..i]

		Line:FontTemplate()
	end
end

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true or not E.private.mui.skins.blizzard.quest then return end

	local QuestFrame = _G.QuestFrame
	MER.NPC:Register(QuestFrame)

	local QuestLogFrame = _G.QuestLogFrame
	if QuestLogFrame.backdrop then
		QuestLogFrame.backdrop:Styling()
	end
	MER:CreateBackdropShadow(QuestLogFrame)

	hooksecurefunc('QuestWatch_Update', CreateHeaderPanels)
end

S:AddCallback("QuestFrame", LoadSkin)
