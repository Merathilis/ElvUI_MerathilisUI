local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

function module:ElvUIProfileMovers(callback)
	local pf = self:BuildProfile()

	-- Process all movers
	F.ProcessMovers(pf)

	-- Merge Tables
	F.Table.Crush(E.db.movers, pf.movers)

	F.Event.RunNextFrame(function()
		F.Event.ContinueAfterElvUIUpdate(function()
			E:StaggeredUpdateAll()
			if callback then
				F.Event.ContinueAfterElvUIUpdate(callback)
			end
		end)
	end, 0.2)
end

function module:ExecuteElvUIUpdate(callback, noMovers)
	-- Update ElvUI
	F.Event.RunNextFrame(function()
		F.Event.ContinueAfterElvUIUpdate(function()
			E:StaggeredUpdateAll()

			if not noMovers then
				F.Event.ContinueAfterElvUIUpdate(F.Event.GenerateClosure(self.ElvUIProfileMovers, self, callback))
			else
				F.Event.ContinueAfterElvUIUpdate(callback)
			end
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
