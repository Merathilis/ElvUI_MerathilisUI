local MER, E, L, V, P, G = unpack(select(2, ...))

local cargBags = _cargBags
local LibItemLevel = LibStub:GetLibrary("LibItemLevel-MerathilisUI")

local function noop() end

local function ItemButton_Scaffold(self)
	self:SetSize(E.db.mui.bags.bagSize, E.db.mui.bags.bagSize)

	local name = self:GetName()
	self.Icon = _G[name.."IconTexture"]
	self.Count = _G[name.."Count"]
	self.Cooldown = _G[name.."Cooldown"]
	self.Quest = _G[name.."IconQuestTexture"]
	self.Border = _G[name.."NormalTexture"]

	self.Icon:SetTexCoord(unpack(E.TexCoords))

	if not self.itemLevel and E.db.mui.bags.itemLevel then
		self.itemLevel = self:CreateFontString(nil, "OVERLAY")
		self.itemLevel:SetPoint("TOPRIGHT", 1, -2)
		self.itemLevel:FontTemplate(nil, nil, "OUTLINE")
	end

	if not self.border then
		local border = CreateFrame("Frame", nil, self)
		border:SetAllPoints()
		border:SetFrameLevel(self:GetFrameLevel()+1)
		self.border = border
		self.border:CreateBorder()
		E:GetModule("muiSkins"):CreateBackdropTexture(self, 0.6)
	end

	if self.Cooldown then
		E:RegisterCooldown(self.Cooldown)
	end
end

local function IsItemEligibleForItemLevelDisplay(classID, subClassID, equipLoc, rarity)
	if ((classID == 3 and subClassID == 11) --Artifact Relics
		or (equipLoc ~= nil and equipLoc ~= "" and equipLoc ~= "INVTYPE_BAG" and equipLoc ~= "INVTYPE_QUIVER" and equipLoc ~= "INVTYPE_TABARD"))
		and (rarity and rarity > 1) then

		return true
	end

	return false
end

local function ItemButton_Update(self, item)
	self.Icon:SetTexture(item.texture or self.bgTex)

	if(item.count and item.count > 1) then
		self.Count:SetText(item.count >= 1e3 and "*" or item.count)
		self.Count:Show()
	else
		self.Count:Hide()
	end
	self.count = item.count -- Thank you Blizz for not using local variables >.> (BankFrame.lua @ 234 )

	-- self.Quest:Hide()
	self:UpdateCooldown(item)
	self:UpdateLock(item)

	if (item.link) then
		if MER:IsItemUnusable(item.link) then
			SetItemButtonTextureVertexColor(self, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
		else
			SetItemButtonTextureVertexColor(self, 1, 1, 1)
		end

		if item.questID and not item.questActive then
			self.Icon:SetInside()
			self:StyleButton()
			self:SetBackdropColor(0, 0, 0)
			self.border:SetBackdropBorderColor(1.0, 0.2, 0.2)
		elseif item.questID or item.isQuestItem then
			self.Icon:SetInside()
			self:StyleButton()
			self:SetBackdropColor(0, 0, 0)
			self.border:SetBackdropBorderColor(1.0, 0.2, 0.2)
		elseif item.rarity and item.rarity > 1 then
			local r, g, b = GetItemQualityColor(item.rarity)
			self.Icon:SetInside()
			self:StyleButton()
			self:SetBackdropColor(0, 0, 0)
			self.border:SetBackdropBorderColor(r, g, b)
		else
			self.Icon:SetAllPoints()
			self:StyleButton(true)
			self:SetBackdropColor(0, 0, 0, 0, 0)
			self.border:SetBackdropBorderColor(unpack(E["media"].bordercolor))
		end
	else
		self.Icon:SetAllPoints()
		self:StyleButton(true)
		self:SetBackdropColor(0, 0, 0, 0)
		self.border:SetBackdropBorderColor(unpack(E["media"].bordercolor))
	end

	if (self.JunkIcon) then
		if (item.rarity) and (item.rarity == LE_ITEM_QUALITY_POOR and not item.noValue) then
			self.JunkIcon:Show()
		else
			self.JunkIcon:Hide()
		end
	end

	if (self.UpgradeIcon) then
		local itemIsUpgrade = IsContainerItemAnUpgrade(item.bagID, item.slotID)
		if itemIsUpgrade == nil then
			self.UpgradeIcon:SetShown(false)
		else
			self.UpgradeIcon:SetShown(itemIsUpgrade)
		end
	end

	if(C_NewItems.IsNewItem(item.bagID, item.slotID)) then
		ActionButton_ShowOverlayGlow(self)
	else
		ActionButton_HideOverlayGlow(self)
	end

	if E.db.mui.bags.itemLevel then
		self.itemLevel:SetText("")
		local clink = GetContainerItemLink(item.bagID, item.slotID)
		if (clink) then
			local itemEquipLoc, _, _, itemClassID, itemSubClassID = select(9, GetItemInfo(clink))
			local _, iLvl = LibItemLevel:GetItemInfo(clink)
			local r, g, b

			if(item.rarity) then
				r, g, b = GetItemQualityColor(item.rarity);
			end

			if iLvl and IsItemEligibleForItemLevelDisplay(itemClassID, itemSubClassID, itemEquipLoc, item.rarity) then
				if iLvl >= 1 then
					self.itemLevel:SetText(iLvl)
					self.itemLevel:SetTextColor(r, g, b)
				end
			end
		end
	end

	if(self.OnUpdate) then self:OnUpdate(item) end
end

local function ItemButton_UpdateCooldown(self, item)
	if(item.cdEnable == 1 and item.cdStart and item.cdStart > 0) then
		self.Cooldown:SetCooldown(item.cdStart, item.cdFinish)
		self.Cooldown:Show()
	else
		self.Cooldown:Hide()
	end

	if(self.OnUpdateCooldown) then self:OnUpdateCooldown(item) end
end

local function ItemButton_UpdateLock(self, item)
	self.Icon:SetDesaturated(item.locked)

	if(self.OnUpdateLock) then self:OnUpdateLock(item) end
end

local function ItemButton_OnEnter(self)
	ActionButton_HideOverlayGlow(self)
end

cargBags:RegisterScaffold("ElvUI_MerathilisUI", function(self)
	self.glowTex = "Interface\\Buttons\\UI-ActionButton-Border" --! @property glowTex <string> The textures used for the glow
	self.glowAlpha = 0.8 --! @property glowAlpha <number> The alpha of the glow texture
	self.glowBlend = "ADD" --! @property glowBlend <string> The blendMode of the glow texture
	self.glowCoords = { 14/64, 50/64, 14/64, 50/64 } --! @property glowCoords <table> Indexed table of texCoords for the glow texture
	self.bgTex = nil --! @property bgTex <string> Texture used as a background if no item is in the slot

	self.CreateFrame = ItemButton_CreateFrame
	self.Scaffold = ItemButton_Scaffold

	self.Update = ItemButton_Update
	self.UpdateCooldown = ItemButton_UpdateCooldown
	self.UpdateLock = ItemButton_UpdateLock
	self.UpdateQuest = ItemButton_Update

	self.OnEnter = ItemButton_OnEnter
	self.OnLeave = ItemButton_OnLeave
end)