local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")
local S = E:GetModule("Skins")

local _G = _G

local function reskinToast(toast)
	toast:SetTemplate("Transparent")
	toast:CreateShadow()

	toast.texture:Kill()

	S:HandleButton(toast.reset)
	toast.reset:SetWidth(toast.reset:GetWidth() - 3)
	S:HandleButton(toast.lock)
	toast.lock:SetWidth(toast.lock:GetWidth() - 3)
end

local function reskinSetting(frame)
	for i = 1, 5 do
		S:HandleCheckBox(frame["color" .. i])
		frame["color" .. i]:Size(24)
		F.MoveFrameWithOffset(frame["color" .. i], 0, -10)
		F.MoveFrameWithOffset(frame["color" .. i].Text, 0, -2)

		S:HandleCheckBox(frame["text" .. i])
		frame["text" .. i]:Size(24)
		F.MoveFrameWithOffset(frame["text" .. i], 0, -10)
		F.MoveFrameWithOffset(frame["text" .. i].Text, 0, -2)
	end

	F.MoveFrameWithOffset(frame.label3, 0, -50)

	S:HandleCheckBox(frame.toast)
	frame.toast:Size(28)

	F.MoveFrameWithOffset(frame.description2, 0, -3)

	S:HandleSliderFrame(frame.fade2)

	S:HandleCheckBox(frame.sound)
	frame.sound:Size(24)
	F.MoveFrameWithOffset(frame.sound, 0, -10)

	S:HandleButton(frame.toggle)
	S:HandleButton(frame.reset)
end

function module:ParagonReputation()
	if not E.private.mui.skins.addonSkins.enable or not E.private.mui.skins.addonSkins.paragonReputation then
		return
	end

	if _G.ParagonReputation_Toast then
		reskinToast(_G.ParagonReputation_Toast)
	end

	self:ReskinSettingFrame("Paragon Reputation", reskinSetting)
end

module:AddCallbackForAddon("ParagonReputation")
