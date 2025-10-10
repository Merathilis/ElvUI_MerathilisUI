local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local TT = E:GetModule("Tooltip")

local type = type
local select = select

function module:LibQTip_UpdateScrolling(tooltip, ...)
	local slider = tooltip and tooltip.slider
	if slider and not slider.__MERSkin then
		self:Proxy("HandleSliderFrame", slider)
	end
	self.hooks[tooltip].UpdateScrolling(tooltip, ...)
end

function module:LibQTip_SetCell(tooltip, ...)
	local setCell = self.hooks[tooltip] and self.hooks[tooltip].SetCell
	if not setCell then
		return
	end

	local lineNum, colNum, value, arg = select(1, ...)

	-- Only style if we have valid parameters and string value
	if type(lineNum) == "number" and type(colNum) == "number" then
		if type(value) == "string" then
			local styledValue = self:StyleTextureString(value)
			if styledValue ~= value then
				-- Replace the value in the argument list
				return setCell(tooltip, lineNum, colNum, styledValue, select(4, ...))
			end
		elseif arg and type(arg) == "table" and type(arg.AcquireCell) == "function" then
			if not arg.__MERSkin then
				local AcquireCell = arg.AcquireCell
				arg.AcquireCell = function(prototype, ...)
					local cell = AcquireCell(prototype, ...)
					if cell and cell.texture and not cell.__MERSkin then
						self:TryCropTexture(cell.texture)
						cell.__MERSkin = true
					end
					return cell
				end

				arg.__MERSkin = true
			end

			return setCell(tooltip, lineNum, colNum, value, arg, select(5, ...))
		end
	end

	-- Fall back to original method
	return setCell(tooltip, ...)
end

function module:ReskinLibQTip(lib)
	for _, tt in lib:IterateTooltips() do
		F.WaitFor(function()
			return E.private.mui and E.private.mui.skins and E.private.mui.skins.libraries
		end, function()
			if not E.private.mui.skins.libraries.libQTip then
				return
			end

			TT:SetStyle(tt)

			if tt.UpdateScrolling and not self:IsHooked(tt, "UpdateScrolling") then
				self:RawHook(tt, "UpdateScrolling", "LibQTip_UpdateScrolling")
			end

			if tt.SetCell and not self:IsHooked(tt, "SetCell") then
				self:RawHook(tt, "SetCell", "LibQTip_SetCell")
			end
		end)
	end
end

function module:LibQTip(lib)
	if lib.Acquire then
		self:SecureHook(lib, "Acquire", "ReskinLibQTip")
	end
end

module:AddCallbackForLibrary("LibQTip-1.0", "LibQTip")
module:AddCallbackForLibrary("LibQTip-1.0RS", "LibQTip")
