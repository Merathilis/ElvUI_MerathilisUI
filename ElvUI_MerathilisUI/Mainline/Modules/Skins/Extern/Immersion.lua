local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')

if not IsAddOnLoaded('AddOnSkins') then return end
local AS = unpack(AddOnSkins)
if not AS:CheckAddOn('Immersion') then return end

function MER:SkinImmersion(event, addon)
	module:CreateShadow(_G.ImmersionFrame.TalkBox.BackgroundFrame.Backdrop)
	module:CreateShadow(_G.ImmersionFrame.TalkBox.Elements.Backdrop)

	ImmersionFrame:HookScript('OnUpdate', function(self)
		for _, Button in ipairs(self.TitleButtons.Buttons) do
			if Button and not Button.Backdrop then
				module:CreateBackdropShadow(Button.Backdrop)
			end
		end
	end)
end

AS:RegisterSkin("Immersion", MER.SkinImmersion, 2, "ADDON_LOADED")
