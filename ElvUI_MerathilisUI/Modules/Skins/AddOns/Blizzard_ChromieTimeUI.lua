local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkins()
	if not module:CheckDB("chromieTime", "chromieTime") then
		return
	end

	local frame = _G.ChromieTimeFrame
	frame:StripTextures()
	frame.Background:Hide()
	frame:SetTemplate('Transparent')
	module:CreateShadow(frame)

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
