local MER, F, E, L, V, P, G = unpack(ElvUI_MerathilisUI)
local module = MER.Modules.Skins

local _G = _G
local select = select

function module:Blizzard_AlliedRacesUI()
	if not module:CheckDB("alliedRaces", "AlliedRaces") then
		return
	end

	local AlliedRacesFrame = _G.AlliedRacesFrame

	module:CreateBackdropShadow(AlliedRacesFrame)
	select(2, AlliedRacesFrame.ModelFrame:GetRegions()):Hide()
	AlliedRacesFrame.FrameBackground:Hide()

	local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
	scrollFrame.Child.ObjectivesFrame:StripTextures()
	scrollFrame.Child.ObjectivesFrame:SetTemplate("Transparent")
	scrollFrame.ScrollBar.ScrollUpBorder:Hide()
	scrollFrame.ScrollBar.ScrollDownBorder:Hide()

	AlliedRacesFrame.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(1, .8, 0)
	scrollFrame.Child.RaceDescriptionText:SetTextColor(1, 1, 1)
	scrollFrame.Child.RacialTraitsLabel:SetTextColor(1, .8, 0)

	AlliedRacesFrame:HookScript("OnShow", function(self)
		local parent = scrollFrame.Child
		for i = 1, parent:GetNumChildren() do
			local bu = select(i, parent:GetChildren())
			if bu.Icon then
				bu.Text:SetTextColor(1, 1, 1)
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_AlliedRacesUI")
