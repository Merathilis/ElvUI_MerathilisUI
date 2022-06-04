local MER, F, E, L, V, P, G = unpack(select(2, ...))
local S = E:GetModule('Skins')

local _G = _G
local select = select

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.alliedRaces ~= true or E.private.mui.skins.blizzard.AlliedRaces ~= true then return end

	local AlliedRacesFrame = _G.AlliedRacesFrame

	if AlliedRacesFrame.backdrop then
		AlliedRacesFrame.backdrop:Styling()
	end

	MER:CreateBackdropShadow(AlliedRacesFrame)
	select(2, AlliedRacesFrame.ModelFrame:GetRegions()):Hide()
	AlliedRacesFrame.FrameBackground:Hide()

	local scrollFrame = AlliedRacesFrame.RaceInfoFrame.ScrollFrame
	scrollFrame.Child.ObjectivesFrame:StripTextures()
	scrollFrame.Child.ObjectivesFrame:CreateBackdrop("Transparent")
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

S:AddCallbackForAddon("Blizzard_AlliedRacesUI", LoadSkin)
