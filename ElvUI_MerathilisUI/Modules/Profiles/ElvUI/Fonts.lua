local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles")

local ipairs, unpack = ipairs, unpack

local function customTextSize(args)
	local ret = {}
	for _, v in ipairs(args) do
		if not v then
			return
		end
		local name, font, size, outline, stopOverride = unpack(v)
		ret[name] = {
			font = stopOverride and font or F.FontOverride(font),
			size = F.FontSizeScaled(size),
			fontOutline = stopOverride and outline or F.FontStyleOverride(font, outline),
		}
	end
	return ret
end

function module:ElvUIFont()
	F.Table.Crush(E.db, {
		-- General
		general = {
			font = F.FontOverride(I.Fonts.Primary),
			fontSize = F.FontSizeScaled(10, 11),
			fontStyle = F.FontStyleOverride(I.Fonts.Primary, "SHADOWOUTLINE"),
		},
	})
end

function module:ApplyFontChange()
	-- Apply Fonts
	self:ElvUIFont()

	-- Update ElvUI Media
	E:UpdateMedia()
	E:UpdateFontTemplates()
end
