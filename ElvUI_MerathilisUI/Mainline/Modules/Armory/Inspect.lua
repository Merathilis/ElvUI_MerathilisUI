local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Armory')
local M = E:GetModule('Misc')
local LSM = E.LSM or E.Libs.LSM

local _G = _G
local pairs = pairs

local GetInventorySlotInfo = GetInventorySlotInfo
local GetInventoryItemLink = GetInventoryItemLink
local GetItemInfo = GetItemInfo
local GetPlayerInfoByGUID = GetPlayerInfoByGUID

local InspectText
local ClassSymbolFrame

function module:UpdateInspect()
	if not _G["InspectFrame"] then return end
	if not module.db.inspect.enable then return end

	local unit = "target"
	if not unit then return end

	local frame, slot, r, g, b
	local itemLink

	for k, _ in pairs(module.Constants.slots) do
		frame = _G[("Inspect")..k]

		slot = GetInventorySlotInfo(k)
		if slot and slot ~= '' then
			-- Reset Data first
			frame.Gradiation:Hide()

			itemLink = GetInventoryItemLink(unit, slot)
			if (itemLink and itemLink ~= nil) then
				if type(itemLink) ~= "string" then return end

				local _, _, itemRarity, _, _, _, _, _, _, _, _, _, _, _, _, setID = GetItemInfo(itemLink)

				-- Gradiation
				if module.db.inspect.gradient.enable then
					frame.Gradiation:Show()
					if module.db.inspect.gradient.setArmor and setID then
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.inspect.gradient.setArmorColor))
					elseif itemRarity and module.db.inspect.gradient.colorStyle == "RARITY" then
						r, g, b = GetItemQualityColor(itemRarity)
						frame.Gradiation.Texture:SetVertexColor(r, g, b)
					elseif module.db.inspect.gradient.colorStyle == "VALUE" then
						frame.Gradiation.Texture:SetVertexColor(unpack(E.media.rgbvaluecolor))
					else
						frame.Gradiation.Texture:SetVertexColor(F.unpackColor(module.db.inspect.gradient.color))
					end
				end
			end
		end
	end

	M:UpdatePageInfo(_G['InspectFrame'], 'Inspect')
end

function module:BuildInspect()
	if not _G["InspectFrame"] then return end
	if not module.db.inspect.enable then return end

	-- Increase the Size
	_G.InspectFrame:Size(450, 444)

	_G.InspectMainHandSlot:SetPoint('BOTTOMLEFT', _G.InspectPaperDollItemsFrame, 'BOTTOMLEFT', 185, 14)

	_G.InspectModelFrame:ClearAllPoints()
	_G.InspectModelFrame:SetPoint('TOPLEFT', _G.InspectHeadSlot, 0, 5)
	_G.InspectModelFrame:SetPoint('RIGHT', _G.InspectHandsSlot)
	_G.InspectModelFrame:SetPoint('BOTTOM', _G.InspectMainHandSlot)

	_G.InspectGuildFrameBanner:ClearAllPoints()
	_G.InspectGuildFrameBanner:Point("TOP", _G.InspectFrameInset, "TOP", 0, -4)

	for id, slotName in pairs(module.Constants.slotIDs) do
		if not id then return end
		local frame = _G["Inspect"..module.Constants.slotIDs[id]]
		local slotHeight = frame:GetHeight()

		if not frame.Gradiation then
			-- Gradiation
			frame.Gradiation = CreateFrame('Frame', nil, frame)
			frame.Gradiation:Size(120, slotHeight + 4)
			frame.Gradiation:SetFrameLevel(_G["InspectModelFrame"]:GetFrameLevel() - 1)

			frame.Gradiation.Texture = frame.Gradiation:CreateTexture(nil, "OVERLAY")
			frame.Gradiation.Texture:SetInside()
			frame.Gradiation.Texture:SetTexture(module.Constants.Gradiation)

			-- color comes from: module:UpdatePageStrings
			if id <= 7 or id == 17 or id == 11 then -- Left Size
				frame.Gradiation:Point("LEFT", _G["Inspect"..slotName], "RIGHT", - _G["Inspect"..slotName]:GetWidth()-4, 0)
				frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
			elseif id <= 16 then -- Right Side
				frame.Gradiation:Point("RIGHT", _G["Inspect"..slotName], "LEFT", _G["Inspect"..slotName]:GetWidth()+4, 0)
				frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
			elseif id == 18 then
				frame.Gradiation:Size(160, slotHeight + 4)
				frame.Gradiation:Point("RIGHT", _G["Inspect"..slotName], "LEFT", _G["Inspect"..slotName]:GetWidth()+4, 0)
				frame.Gradiation.Texture:SetTexCoord(1, 0, 0, 1)
			elseif id == 19 then
				frame.Gradiation:Size(160, slotHeight + 4)
				frame.Gradiation:Point("LEFT", _G["Inspect"..slotName], "RIGHT", - _G["Inspect"..slotName]:GetWidth()-4, 0)
				frame.Gradiation.Texture:SetTexCoord(0, 1, 0, 1)
			end
			frame.Gradiation:Hide()
		end

		if not frame.Warning then
			-- Missing Enchants/Gems Warning
			frame.Warning = CreateFrame('Frame', nil, frame)
			if id <= 7 or id == 17 or id == 11 then -- Left Size
				frame.Warning:Size(7, 41)
				frame.Warning:SetPoint("RIGHT", _G["Inspect"..slotName], "LEFT", 0, 0)
			elseif id <= 16 then -- Right Side
				frame.Warning:Size(7, 41)
				frame.Warning:SetPoint("LEFT", _G["Inspect"..slotName], "RIGHT", 0, 0)
			elseif id == 18 or id == 19 then -- Main Hand/ OffHand
				frame.Warning:Size(41, 7)
				frame.Warning:SetPoint("TOP", _G["Inspect"..slotName], "BOTTOM", 0, 0)
			end

			frame.Warning.Texture = frame.Warning:CreateTexture(nil, "BACKGROUND")
			frame.Warning.Texture:SetInside()
			frame.Warning.Texture:SetTexture(module.Constants.WarningTexture)
			frame.Warning.Texture:SetVertexColor(1, 0, 0)
--
			frame.Warning:SetScript("OnEnter", self.Warning_OnEnter)
			frame.Warning:SetScript("OnLeave", self.Tooltip_OnLeave)
			frame.Warning:Hide()
		end
	end
end

function module:PreSetup()
	if not module.db.inspect.enable then return end
	MER:RegisterEvent("INSPECT_READY", function(_, unit)
		E:Delay(0.1, function() --Needs a bit delay
			self:AddInspectIcon(unit)
		end)

		if not E.db.general.itemLevel.displayInspectInfo then
			module:UpdateInspectInfo()

			MER:UnregisterEvent("INSPECT_READY")
			M:ClearPageInfo(_G["InspectFrame"], "Inspect")
		end
	end)
end

function module:AddInspectIcon(unit)
	if not _G["InspectFrame"] then return end
	if not module.db.inspect.classIcon then
		return
	end

	local titleText, coloredTitleText

	local _, class, _, race = GetPlayerInfoByGUID(unit)
	if class or race then
		local classColor = E:ClassColor(class, true)
		ClassSymbolFrame = ("|T"..(MER.ClassIcons[class]..".tga:0:0:0:0|t"))
		InspectText = _G.InspectFrameTitleText:GetText()

		if InspectText then
			coloredTitleText = E:TextGradient(InspectText, F.ClassGradient[class]["r1"], F.ClassGradient[class]["g1"], F.ClassGradient[class]["b1"], F.ClassGradient[class]["r2"], F.ClassGradient[class]["g2"], F.ClassGradient[class]["b2"])

			_G.InspectFrameTitleText:SetFont(E.LSM:Fetch('font', E.db.general.font), 16, E.db.general.fontStyle)
			_G.InspectFrameTitleText:SetTextColor(classColor.r, classColor.g, classColor.b)
			_G.InspectFrameTitleText:SetWidth(200)
			if not InspectText:match("|T") then
				titleText = ClassSymbolFrame.." "..coloredTitleText
			else
				return
			end
			_G.InspectFrameTitleText:SetText(titleText)
		end
	end

	M:UpdatePageInfo(_G['InspectFrame'], 'Inspect')
end

function module:LoadAndSetupInspect()
	self:BuildInspect()
	self:UpdateInspect()
end
