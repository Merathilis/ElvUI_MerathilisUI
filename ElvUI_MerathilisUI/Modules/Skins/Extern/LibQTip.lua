local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local TT = E:GetModule("Tooltip")

local _G = _G
local type = type
local select = select
local pairs = pairs
local LibStub = _G.LibStub

function module:ReskinLibQTip(lib)
	for _, tt in lib:IterateTooltips() do
		TT:SetStyle(tt)
		if tt.SetCell and not self:IsHooked(tt, "SetCell") then
			self:RawHook(tt, "SetCell", function(tooltip, ...)
				local lineNum, colNum, value = select(1, ...)

				-- Only style if we have valid parameters and string value
				if type(lineNum) == "number" and type(colNum) == "number" and type(value) == "string" then
					local styledValue = self:StyleTextureString(value)
					if styledValue ~= value then
						-- Replace the value in the argument list
						return self.hooks[tooltip].SetCell(tooltip, lineNum, colNum, styledValue, select(4, ...))
					end
				end

				-- Call original with all original parameters
				return self.hooks[tooltip].SetCell(tooltip, ...)
			end)
		end
	end
end

function module:LibQTip()
	for _, libName in pairs({ "LibQTip-1.0", "LibQTip-1.0RS" }) do
		local lib = LibStub(libName, true)
		if lib and lib.Acquire then
			self:SecureHook(lib, "Acquire", "ReskinLibQTip")
		end
	end
end

module:AddCallback("LibQTip")
