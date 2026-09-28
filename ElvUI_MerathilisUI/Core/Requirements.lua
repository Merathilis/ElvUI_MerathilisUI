local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)

local format = format
local ipairs = ipairs
local type = type

local R = I.Enum.Requirements

-------------------------------------------------------------------------------
--  Requirements
--  Every requirement has a check (true = met) and the reason shown in the
--  options when it isn't. Lists of requirements per feature: I.Requirements.
-------------------------------------------------------------------------------
local function ElvUIModule(name, isEnabled)
	return {
		check = isEnabled,
		reason = function()
			return format(L["Requires ElvUI's %s module to be enabled."], name)
		end,
	}
end

local requirements = {
	[R.MERUI_PROFILE] = {
		check = F.IsMERProfile,
		reason = function()
			return L["No MerathilisUI profile installed."]
		end,
	},
	[R.ELVUI_ACTIONBARS_ENABLED] = ElvUIModule(L["ActionBars"], function()
		return E.private.actionbar.enable
	end),
	[R.ELVUI_UNITFRAMES_ENABLED] = ElvUIModule(L["UnitFrames"], function()
		return E.private.unitframe.enable
	end),
	[R.ELVUI_NAMEPLATES_ENABLED] = ElvUIModule(L["NamePlates"], function()
		return E.private.nameplates.enable
	end),
	[R.ELVUI_CHAT_ENABLED] = ElvUIModule(L["Chat"], function()
		return E.private.chat.enable
	end),
	[R.ELVUI_MINIMAP_ENABLED] = ElvUIModule(L["Minimap"], function()
		return E.private.general.minimap.enable
	end),
	[R.ELVUI_BAGS_ENABLED] = ElvUIModule(L["Bags"], function()
		return E.private.bags.enable
	end),
	[R.ELTRUISM_DISABLED] = {
		check = function()
			return not E:IsAddOnEnabled("ElvUI_EltreumUI")
		end,
		reason = function()
			return L["Not available while EltruismUI is enabled."]
		end,
	},
	[R.BENIKUI_DISABLED] = {
		check = function()
			return not E:IsAddOnEnabled("ElvUI_BenikUI")
		end,
		reason = function()
			return L["Not available while BenikUI is enabled."]
		end,
	},
}

---First requirement that isn't met, or true when all are met
---@param list number|number[]|nil requirement or list of requirements (I.Enum.Requirements)
---@param skipProfile boolean? don't require a MerathilisUI profile
---@return number|true
function MER:CheckRequirements(list, skipProfile)
	if not skipProfile and not requirements[R.MERUI_PROFILE].check() then
		return R.MERUI_PROFILE
	end

	if type(list) ~= "table" then
		list = { list }
	end

	for _, requirement in ipairs(list) do
		local info = requirements[requirement]
		if info and requirement ~= R.MERUI_PROFILE and not info.check() then
			return requirement
		end
	end

	return true
end

---@param list number|number[]|nil
---@param skipProfile boolean?
---@return boolean
function MER:HasRequirements(list, skipProfile)
	return self:CheckRequirements(list, skipProfile) == true
end

---Localized reason why a requirement isn't met
---@param requirement number
---@return string?
function MER:GetRequirementString(requirement)
	local info = requirements[requirement]
	if not info then
		F.Developer.LogDebug("GetRequirementString: unknown requirement", requirement)
		return
	end

	return info.reason()
end
