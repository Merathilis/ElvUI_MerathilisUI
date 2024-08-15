local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local pairs = pairs

function module:LibUIDropDownMenu()
	local DD = _G.LibStub("LibUIDropDownMenu-4.0", true)

	if not DD then
		return
	end

	for _, frame in pairs({
		_G.L_DropDownList1Backdrop,
		_G.L_DropDownList1MenuBackdrop,
		_G.L_DropDownList2Backdrop,
		_G.L_DropDownList2MenuBackdrop,
	}) do
		if frame and not S.L_UIDropDownMenuSkinned and not frame.__MERSkin then
			frame:SetTemplate("Transparent")
		end
		frame:SetTemplate("Transparent")
		self:CreateShadow(frame)
		if frame.NineSlice then
			frame.NineSlice:Kill()
		end
	end

	S.L_UIDropDownMenuSkinned = true
end

module:AddCallback("LibUIDropDownMenu")
