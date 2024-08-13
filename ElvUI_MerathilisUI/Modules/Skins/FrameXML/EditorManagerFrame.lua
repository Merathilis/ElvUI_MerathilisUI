local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G

function module:EditorManagerFrame()
	if not module:CheckDB("editor", "editor") then
		return
	end

	local frame = _G.EditModeManagerFrame
	module:CreateBackdropShadow(frame)

	local layout = _G.EditModeNewLayoutDialog
	module:CreateBackdropShadow(layout)

	local import = _G.EditModeImportLayoutDialog
	module:CreateBackdropShadow(import)

	local dialog = _G.EditModeSystemSettingsDialog
	module:CreateBackdropShadow(dialog)

	local settingsDialog = _G.EditModeSystemSettingsDialog
	module:CreateBackdropShadow(settingsDialog)
end

module:AddCallback("EditorManagerFrame")
