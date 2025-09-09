local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local MF = MER:GetModule("MER_MoveFrames")
local C = MER.Utilities.Color

local _G = _G
local hooksecurefunc = hooksecurefunc

local function HandleGameMenuButton(button)
	local text = button:GetFontString()
	if not text then
		return
	end

	F.SetFontOutline(text)
	text:SetTextColor(C.ExtractRGBFromTemplate("neutral-100"))
end

local function ReskinGameMenuButtons(menu)
	for button in menu.buttonPool:EnumerateActive() do
		HandleGameMenuButton(button)
	end

	if menu.ElvUI and not menu.ElvUI.__windSkin then
		hooksecurefunc(menu.ElvUI, "SetFormattedText", HandleGameMenuButton)
		menu.ElvUI.__windSkin = true
	end
end

local function LayoutGameMenuButtons(menu)
	for button in menu.buttonPool:EnumerateActive() do
		F.Move(button, 0, 25)
	end

	menu:Height(menu:GetHeight() - 40)
end

function module:GameMenuFrame()
	if not module:CheckDB("misc", "misc") then
		return
	end

	local GameMenuFrame = _G.GameMenuFrame

	if not GameMenuFrame or E.OtherAddons.ConsolePort then
		return
	end

	-- Create a header panel
	GameMenuFrame.Header:SetTemplate("Transparent")
	self:CreateShadow(GameMenuFrame.Header)
	MF:InternalHandle(GameMenuFrame.Header, GameMenuFrame, false)
	GameMenuFrame.Header:Height(GameMenuFrame.Header.Text:GetHeight() + 22)
	GameMenuFrame.Header:Width(GameMenuFrame:GetWidth() - 2)
	GameMenuFrame.Header:ClearAllPoints()
	GameMenuFrame.Header:Point("BOTTOM", GameMenuFrame, "TOP", 0, 5)
	F.SetFontOutline(GameMenuFrame.Header.Text, nil, "+2")
	F.InternalizeMethod(GameMenuFrame.Header.Text, "SetTextColor", true)
	F.CallMethod(GameMenuFrame.Header.Text, "SetTextColor", C.ExtractRGBFromTemplate("cyan-400"))
	GameMenuFrame.Header.Text:ClearAllPoints()
	GameMenuFrame.Header.Text:Point("CENTER")

	-- Reskin the main buttons
	self:CreateBackdropShadow(GameMenuFrame)
	hooksecurefunc(GameMenuFrame, "Layout", LayoutGameMenuButtons)
	hooksecurefunc(GameMenuFrame, "InitButtons", ReskinGameMenuButtons)
end

module:AddCallback("GameMenuFrame")
