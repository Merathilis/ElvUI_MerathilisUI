local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G
local select = select

local r, g, b = unpack(E["media"].rgbvaluecolor)

local function styleBindingButton(bu)
	local selected = bu.selectedHighlight

	for i = 1, 9 do
		select(i, bu:GetRegions()):Hide()
	end

	selected:SetTexture(E["media"].normTex)
	selected:SetPoint("TOPLEFT", 1, -1)
	selected:SetPoint("BOTTOMRIGHT", -1, 1)
	selected:SetColorTexture(r, g, b,.2)
end

local function LoadSkin()
	if not module:CheckDB("binding", "binding") then
		return
	end

	local KeyBindingFrame = _G.KeyBindingFrame
	if KeyBindingFrame.backdrop then
		KeyBindingFrame.backdrop:Styling()
	end
	module:CreateBackdropShadow(KeyBindingFrame)

	for i = 1, _G.KEY_BINDINGS_DISPLAYED do
		local button1 = _G["KeyBindingFrameKeyBinding"..i.."Key1Button"]
		local button2 = _G["KeyBindingFrameKeyBinding"..i.."Key2Button"]

		button2:SetPoint("LEFT", button1, "RIGHT", 1, 0)

		styleBindingButton(button1)
		styleBindingButton(button2)
	end

	local line = KeyBindingFrame:CreateTexture(nil, "ARTWORK")
	line:SetSize(1, 546)
	line:SetPoint("LEFT", 205, 10)
	line:SetColorTexture(1, 1, 1, .2)
end

S:AddCallbackForAddon("Blizzard_BindingUI", LoadSkin)
