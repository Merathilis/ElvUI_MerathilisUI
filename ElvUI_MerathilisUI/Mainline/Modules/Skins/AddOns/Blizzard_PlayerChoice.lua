local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER.Modules.Skins
local S = E:GetModule('Skins')

local _G = _G

local function ChangeOptions()
	module:CreateShadow(_G.PlayerChoiceFrame)
	_G.PlayerChoiceFrame:Styling()

	local instanceType, _, _, _, _, _, instanceID = select(2, GetInstanceInfo())
	local needDisable = IsInJailersTower() or instanceType == "party" or instanceType == "raid" or instanceID == 2374

	-- Hold shadow in garrison
	if needDisable then
		if instanceID == 1159 then
			needDisable = false
		end
	end

	if _G.PlayerChoiceFrame.shadow then
		if needDisable then
			_G.PlayerChoiceFrame.shadow:Hide()
		else
			_G.PlayerChoiceFrame.shadow:Show()
		end
	end

	if _G.PlayerChoiceFrame.style and (_G.PlayerChoiceFrame.style.stripes and _G.PlayerChoiceFrame.style.mshadow and _G.PlayerChoiceFrame.style.gradient) then
		if needDisable then
			_G.PlayerChoiceFrame.style.stripes:Hide()
			_G.PlayerChoiceFrame.style.mshadow:Hide()
			_G.PlayerChoiceFrame.style.gradient:Hide()
		else
			_G.PlayerChoiceFrame.style.stripes:Show()
			_G.PlayerChoiceFrame.style.mshadow:Show()
			_G.PlayerChoiceFrame.style.gradient:Show()
		end
	end
end


local function LoadSkin()
	if not module:CheckDB("playerChoice", "playerChoice") then
		return
	end

	local frame = _G.PlayerChoiceFrame
	hooksecurefunc(frame, "SetupOptions", ChangeOptions)
end

module:AddCallbackForAddon("Blizzard_PlayerChoice", LoadSkin)
