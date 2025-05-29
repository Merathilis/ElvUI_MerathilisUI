local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local ipairs = ipairs
local type = type

function MER:HasRequirements(requirements, skipProfile)
	local check = self:CheckRequirements(requirements, skipProfile)
	return (check == true) and true or false
end

function MER:GetRequirementString(requirement)
	local reason = ""
	local text = I.Strings.Requirements[requirement]

	if not text or (text == "") or (text == "NO_STRING_DEFINED") then
		F.Developer.LogDebug("GetRequirementString > Could not find string for " .. I.Enum.Requirements[requirement])
	else
		reason = (text ~= "NO_STRING_NEEDED") and text or ""
	end

	return (reason ~= "") and reason or nil
end

function MER:CheckRequirements(requirements, skipProfile)
	if not skipProfile and (not F.IsMERProfile()) then
		return I.Enum.Requirements.MERUI_PROFILE
	end

	if type(requirements) ~= "table" then
		requirements = { requirements }
	end

	for _, requirement in ipairs(requirements) do
		if requirement == I.Enum.Requirements.GRADIENT_MODE_ENABLED then
			if E.db.mui.gradient.enable ~= true then
				return requirement
			end
		elseif requirement == I.Enum.Requirements.GRADIENT_MODE_DISABLED then
			if E.db.mui.gradient.enable ~= false then
				return requirement
			end
		elseif requirement == I.Enum.Requirements.ELVUI_ACTIONBARS_ENABLED then
			if E.private.actionbar.enable ~= true then
				return requirement
			end
		end
	end

	return true
end
