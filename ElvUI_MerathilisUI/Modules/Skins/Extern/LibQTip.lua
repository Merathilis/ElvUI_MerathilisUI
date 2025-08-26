local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local TT = E:GetModule("Tooltip")

local _G = _G

function module:ReskinLibQTip(lib)
	for _, tt in lib:IterateTooltips() do
		TT:SetStyle(tt)
		if tt.SetCell and not self:IsHooked(tt, "SetCell") then
			self:RawHook(tt, "SetCell", function(tt, lineNum, colNum, value, ...)
				if type(value) == "string" then
					value = self:StyleTextureString(value)
				end
				self.hooks[tt].SetCell(tt, lineNum, colNum, value, ...)
			end)
		end
	end
end

function module:LibQTip()
	for _, libName in ipairs({ "LibQTip-1.0", "LibQTip-1.0RS" }) do
		local lib = _G.LibStub(libName, true)
		if lib and lib.Acquire then
			self:SecureHook(lib, "Acquire", "ReskinLibQTip")
		end
	end
end

module:AddCallback("LibQTip")
