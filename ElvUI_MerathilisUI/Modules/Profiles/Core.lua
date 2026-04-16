local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles : AceModule, AceHook-3.0

local pairs = pairs

function module:ExecuteElvUIUpdate(callback)
	-- Update ElvUI
	F.Event.RunNextFrame(function()
		F.Event.ContinueAfterElvUIUpdate(function()
			E:StaggeredUpdateAll()

			F.Event.ContinueAfterElvUIUpdate(callback)
		end)
	end, 0.2)
end

function module:UpdateProfileForGradient()
	local layouts = I.GradientMode.Layouts[E.db.mui.installer.layout]
	if layouts then
		for unitType in pairs(P.themes.gradientMode.fadeDirection) do
			if layouts.Left[unitType] then
				E.db.mui.themes.gradientMode.fadeDirection[unitType] = I.Enum.GradientMode.Direction.LEFT
			else
				E.db.mui.themes.gradientMode.fadeDirection[unitType] = I.Enum.GradientMode.Direction.RIGHT
			end
		end
	end
end

function module:UpdateProfileForTheme() end

function module:Initialize()
	if self.Initialized then
		return
	end

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
