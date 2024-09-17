local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins")

local _G = _G
local select, unpack = select, unpack

local hooksecurefunc = hooksecurefunc

function module:Blizzard_InspectUI()
	if not module:CheckDB("inspect", "inspect") then
		return
	end

	_G.InspectModelFrame:DisableDrawLayer("OVERLAY")

	module:CreateShadow(_G.InspectFrame)
	module:CreateShadow(_G.InspectPaperDollFrame.ViewButton)
	module:CreateShadow(_G.InspectPaperDollItemsFrame.InspectTalents)

	for i = 1, 4 do
		module:ReskinTab(_G["InspectFrameTab" .. i])
	end

	if _G.InspectModelFrame.backdrop then
		_G.InspectModelFrame.backdrop:Hide()
	end

	for i = 1, 5 do
		select(i, _G.InspectModelFrame:GetRegions()):Hide()
	end

	_G.InspectPaperDollFrame.ViewButton:ClearAllPoints()
	_G.InspectPaperDollFrame.ViewButton:SetPoint("TOP", _G.InspectFrame, 0, -45)

	-- Character
	select(11, _G.InspectMainHandSlot:GetRegions()):Hide()

	local slots = {
		"Head",
		"Neck",
		"Shoulder",
		"Shirt",
		"Chest",
		"Waist",
		"Legs",
		"Feet",
		"Wrist",
		"Hands",
		"Finger0",
		"Finger1",
		"Trinket0",
		"Trinket1",
		"Back",
		"MainHand",
		"SecondaryHand",
		"Tabard",
	}

	for i = 1, #slots do
		local slot = _G["Inspect" .. slots[i] .. "Slot"]
		local border = slot.IconBorder

		_G["Inspect" .. slots[i] .. "SlotFrame"]:Hide()

		slot:SetNormalTexture("")
		slot:SetPushedTexture("")
		slot.icon:SetTexCoord(unpack(E.TexCoords))

		border:SetDrawLayer("BACKGROUND")
	end

	hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.IconBorder:SetTexture(E["media"].normTex)
		button.icon:SetShown(button.hasItem)
	end)

	for i = 1, 4 do
		local tab = _G["InspectFrameTab" .. i]
		if tab then
			module:ReskinTab(tab)
			if i ~= 1 then
				tab:SetPoint("LEFT", _G["InspectFrameTab" .. i - 1], "RIGHT", -15, 0)
			end
		end
	end
end

module:AddCallbackForAddon("Blizzard_InspectUI")
