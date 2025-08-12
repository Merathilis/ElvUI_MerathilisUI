local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G
local hooksecurefunc = hooksecurefunc

local function HandleBackdrop(frame)
	local dropdown = (frame and frame.NineSlice) or frame
	if dropdown and not dropdown.template then
		dropdown:SetTemplate("Transparent")
	end

	if dropdown and dropdown.template then
		module:CreateShadow(dropdown)
	end
end

function module:S_SkinLibDropDownMenu(_, prefix)
	if self[prefix .. "_UIDropDownMenuSkinned"] then
		return
	end

	if not E.private.mui then
		self:AddCallback("SkinLibDropDown" .. prefix, function()
			self:S_SkinLibDropDownMenu(nil, prefix)
		end)
		return
	end

	local key = (prefix == "L4" or prefix == "L3") and "L" or prefix

	HandleBackdrop(_G[key .. "_DropDownList1Backdrop"])
	HandleBackdrop(_G[key .. "_DropDownList1MenuBackdrop"])

	self[prefix .. "_UIDropDownMenuSkinned"] = true

	local function reskin()
		local lvls = _G[(key == "Lib" and "LIB" or key) .. "_UIDROPDOWNMENU_MAXLEVELS"] or 1
		for i = 1, lvls do
			HandleBackdrop(_G[key .. "_DropDownList" .. i .. "Backdrop"])
			HandleBackdrop(_G[key .. "_DropDownList" .. i .. "MenuBackdrop"])
		end
	end

	local lib = prefix == "L4" and LibStub.libs["LibUIDropDownMenu-4.0"]
	if lib and not lib.UIDropDownMenu_CreateFrames then
		RunNextFrame(function()
			F.TaskManager:OutOfCombat(function()
				reskin()
				hooksecurefunc(lib, "UIDropDownMenu_CreateFrames", reskin)
			end)
		end)
		return
	end

	if _G[key .. "_UIDropDownMenu_CreateFrames"] then
		reskin()
		hooksecurefunc(lib or _G, (lib and "" or key .. "_") .. "UIDropDownMenu_CreateFrames", reskin)
	end
end

module:SecureHook(S, "SkinLibDropDownMenu", "S_SkinLibDropDownMenu")
