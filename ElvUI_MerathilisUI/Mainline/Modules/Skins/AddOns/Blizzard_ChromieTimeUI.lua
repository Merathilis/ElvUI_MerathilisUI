local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkins()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.chromieTime ~= true or E.private.mui.skins.blizzard.chromieTime ~= true then return end

	local frame = _G.ChromieTimeFrame
	frame:StripTextures()
	frame.Background:Hide()
	frame:CreateBackdrop('Transparent')
	frame.backdrop:Styling()
	MER:CreateBackdropShadow(frame)

	local header = frame.Title
	header:DisableDrawLayer('BACKGROUND')
	header.Text:SetFontObject(_G.SystemFont_Huge1)
	module:CreateBDFrame(header, .25)

	frame.CurrentlySelectedExpansionInfoFrame.Background:Hide()
	module:CreateBDFrame(frame.CurrentlySelectedExpansionInfoFrame, .25)
	frame.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(1, .8, 0)
	frame.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(1, 1, 1)
end

S:AddCallbackForAddon("Blizzard_ChromieTimeUI", LoadSkins)
