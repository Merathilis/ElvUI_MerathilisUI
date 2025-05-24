local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_RaidInfoFrame")

local strsplit = strsplit
local ceil = math.ceil

local CreateFrame = CreateFrame
local IsInRaid = IsInRaid
local InCombatLockdown = InCombatLockdown
local GetNumGroupMembers = GetNumGroupMembers
local UnitGroupRolesAssigned = UnitGroupRolesAssigned
local UnitExists = UnitExists

function module:CreateTooltip()
	if not self.frame then
		return
	end

	self.frame:EnableMouse(true)

	self.frame:SetScript("OnEnter", function()
		GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
		GameTooltip:AddLine(MER.Title .. L[" Raid Info Frame"], 1, 1, 1)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(
			L["Displays the current count of Tanks, Healers, and DPS in your raid group."],
			nil,
			nil,
			nil,
			true
		)
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(L["|cffFFFFFFLeft Click:|r Toggle Raid Frame"])
		GameTooltip:AddLine(L["|cffFFFFFFRight Click:|r Toggle Settings"])
		GameTooltip:Show()
	end)

	self.frame:SetScript("OnLeave", function()
		GameTooltip:Hide()
	end)

	self.frame:SetScript("OnMouseUp", function(_, button)
		if button == "LeftButton" then
			ToggleRaidFrame()
		elseif button == "RightButton" then
			E:ToggleOptions("mui,misc,raidInfo")
		end
	end)
end
function module:Create()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "MER_RaidInfoFrame", E.UIParent, "BackdropTemplate")
	local point, anchor, attachTo, x, y = strsplit(",", F.Position(strsplit(",", self.db.position)))
	frame:SetPoint(point, anchor, attachTo, x, y)

	E:CreateMover(
		frame,
		"MER_RaidInfoFrame",
		MER.Title .. " Raid Info Frame",
		nil,
		nil,
		nil,
		"ALL,SOLO,PARTY,RAID,MERATHILISUI",
		nil,
		"mui,misc,raidInfo"
	)

	frame:SetBackdrop({
		bgFile = E.media.blankTex,
		edgeFile = E.media.blankTex,
		edgeSize = 1,
	})

	frame:SetBackdropBorderColor(0, 0, 0, 1)

	-- Tank
	frame.tankIcon = frame:CreateTexture(nil, "ARTWORK")
	frame.tankText = frame:CreateFontString(nil, "OVERLAY")
	frame.tankText:FontTemplate(nil, F.FontSizeScaled(self.db.size), "SHADOWOUTLINE")
	frame.tankText:SetText("2")

	-- Healer
	frame.healIcon = frame:CreateTexture(nil, "ARTWORK")
	frame.healText = frame:CreateFontString(nil, "OVERLAY")
	frame.healText:FontTemplate(nil, F.FontSizeScaled(self.db.size), "SHADOWOUTLINE")
	frame.healText:SetText("4")

	-- DPS
	frame.dpsIcon = frame:CreateTexture(nil, "ARTWORK")
	frame.dpsText = frame:CreateFontString(nil, "OVERLAY")
	frame.dpsText:FontTemplate(nil, F.FontSizeScaled(self.db.size), "SHADOWOUTLINE")
	frame.dpsText:SetText("14")

	-- Finalize
	frame:Hide()
	self.frame = frame

	self:CreateTooltip()
	self:UpdateIcons()
	self:UpdateSize()
	self:UpdateSpacing()
	self:UpdateBackdrop()
	self:Update()

	frame:RegisterEvent("GROUP_ROSTER_UPDATE")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", function()
		self:Update()
	end)
end

function module:UpdateIcons()
	local theme = E.db.mui.elvUIIcons.roleIcons.theme

	if self.frame.tankIcon then
		self.frame.tankIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.Icons.Role[theme].raid1.TANK))
	end
	if self.frame.healIcon then
		self.frame.healIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.Icons.Role[theme].raid1.HEALER))
	end
	if self.frame.dpsIcon then
		self.frame.dpsIcon:SetTexture(F.GetMedia(I.Media.RoleIcons, I.Icons.Role[theme].raid1.DAMAGER))
	end
end

function module:UpdateSize()
	local size = self.db.size
	local font = F.GetFontPath(I.Fonts.Primary)

	self.frame.tankIcon:SetSize(size, size)
	self.frame.healIcon:SetSize(size, size)
	self.frame.dpsIcon:SetSize(size, size)

	self.frame.tankText:SetFont(font, size, "SHADOWOUTLINE")
	self.frame.healText:SetFont(font, size, "SHADOWOUTLINE")
	self.frame.dpsText:SetFont(font, size, "SHADOWOUTLINE")

	self:UpdateLayout()
end

function module:UpdateSpacing()
	local spacing = self.db.spacing
	local padding = self.db.padding

	self.frame.tankIcon:SetPoint("LEFT", self.frame, "LEFT", padding, 0)
	self.frame.tankText:SetPoint("LEFT", self.frame.tankIcon, "RIGHT", spacing, 0)

	self.frame.healIcon:SetPoint("LEFT", self.frame.tankText, "RIGHT", spacing, 0)
	self.frame.healText:SetPoint("LEFT", self.frame.healIcon, "RIGHT", spacing, 0)

	self.frame.dpsIcon:SetPoint("LEFT", self.frame.healText, "RIGHT", spacing, 0)
	self.frame.dpsText:SetPoint("LEFT", self.frame.dpsIcon, "RIGHT", spacing, 0)

	self:UpdateLayout()
end

function module:UpdateBackdrop()
	local c = self.db.backdropColor
	self.frame:SetBackdropColor(c.r, c.g, c.b, c.a)
end

function module:UpdateLayout()
	local size = self.db.size
	local spacing = self.db.spacing
	local padding = self.db.padding

	local width = size
		+ spacing
		+ self.frame.tankText:GetStringWidth()
		+ spacing
		+ size
		+ spacing
		+ self.frame.healText:GetStringWidth()
		+ spacing
		+ size
		+ spacing
		+ self.frame.dpsText:GetStringWidth()

	local height = size + (padding * 2)

	self.frame:SetWidth(ceil(width + (padding * 2)))
	self.frame:SetHeight(height)
end

function module:ToggleFrame()
	if not self.frame then
		return
	end

	if self.frame:IsShown() then
		self.frame:Hide()
	else
		self.frame:Show()
	end
end

function module:Update()
	if not self.frame then
		return
	end

	if IsInRaid() and not InCombatLockdown() then
		self.frame:Show()

		local tank, heal, dps = 0, 0, 0
		for i = 1, GetNumGroupMembers() do
			local unit = "raid" .. i
			if UnitExists(unit) then
				local role = UnitGroupRolesAssigned(unit)
				if role == "TANK" then
					tank = tank + 1
				elseif role == "HEALER" then
					heal = heal + 1
				elseif role == "DAMAGER" then
					dps = dps + 1
				end
			end
		end

		self.frame.tankText:SetText(tank)
		self.frame.healText:SetText(heal)
		self.frame.dpsText:SetText(dps)

		self:UpdateLayout()
	else
		self.frame:Hide()
	end
end

function module:Enable()
	self:Create()
end

function module:DatabaseUpdate()
	self.db = F.GetDBFromPath("mui.misc.raidInfo")
	if self.db and self.db.enable then
		self:Enable()
	end
end

function module:Initialize()
	if self.Initialized then
		return
	end

	F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(self.DatabaseUpdate, self))
	F.Event.RegisterCallback("MER.DatabaseUpdate", self.DatabaseUpdate, self)

	self.Initialized = true
end

MER:RegisterModule(module:GetName())
