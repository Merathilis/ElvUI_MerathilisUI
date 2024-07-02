local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:ExecuteElvUIUpdate(callback)
	-- Update ElvUI
	F.Event.RunNextFrame(function()
		F.Event.ContinueAfterElvUIUpdate(function()
			E:StaggeredUpdateAll()

			F.Event.ContinueAfterElvUIUpdate(callback)
		end)
	end, 0.2)
end

function module:Initialize()
	if self.Initialized then
		return
	end

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
