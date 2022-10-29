local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("editor", "editor") then
		return
	end

	local frame = _G.EditModeManagerFrame
	frame.backdrop:Styling()
	module:CreateBackdropShadow(frame)

	local layout = _G.EditModeNewLayoutDialog
	layout.backdrop:Styling()
	module:CreateBackdropShadow(layout)

	local import = _G.EditModeImportLayoutDialog
	import.backdrop:Styling()
	module:CreateBackdropShadow(import)

	local dialog = _G.EditModeSystemSettingsDialog
	dialog.backdrop:Styling()
	module:CreateBackdropShadow(dialog)
end

S:AddCallback("EditorManagerFrame", LoadSkin)
