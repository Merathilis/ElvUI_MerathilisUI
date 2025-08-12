local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local function createShadow(frame)
	module:CreateBackdropShadow(frame)
end

function module:SkinMenu(_, manager, _, menuDescription)
	local menu = manager:GetOpenMenu()
	if not menu then
		return
	end

	self:CreateBackdropShadow(menu)
	menuDescription:AddMenuAcquiredCallback(createShadow)
	print("blub")
end

module:SecureHook(S, "SkinMenu")
