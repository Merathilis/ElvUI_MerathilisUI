local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G

function module:Blizzard_ChromieTimeUI()
	if not module:CheckDB("chromieTime", "chromieTime") then
		return
	end

	local frame = _G.ChromieTimeFrame
	frame:StripTextures()
	frame.Background:Hide()
	frame:SetTemplate("Transparent")
	module:CreateShadow(frame)

	local header = frame.Title
	header:DisableDrawLayer("BACKGROUND")
	header.Text:SetFontObject(_G.SystemFont_Huge1)
	module:CreateBDFrame(header, 0.25)

	frame.CurrentlySelectedExpansionInfoFrame.Background:Hide()
	module:CreateBDFrame(frame.CurrentlySelectedExpansionInfoFrame, 0.25)
	frame.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(1, 0.8, 0)
	frame.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(1, 1, 1)
end

module:AddCallbackForAddon("Blizzard_ChromieTimeUI")
