local MER, E, L, V, P, G = unpack(select(2, ...))
local OCD = E:NewModule("OzCooldowns", "AceEvent-3.0")
local LSM = LibStub("LibSharedMedia-3.0")
OCD.modName = L["OzCooldowns"]

--Cache global variables
--Lua functions
local pairs = pairs
local ceil, format = ceil, format
local tinsert = table.insert

--WoW API / Variables
local GetTime = GetTime
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture

--Global variables that we don't cache, list them here for the mikk's Find Globals script
-- GLOBALS:

local MyRace = select(2, UnitRace("player"))
local MyClass = select(2, UnitClass("player"))

local PlayerCooldowns = {}
local Cooldowns = {}
local CooldownFrames = {}

local Blacklist = {
	[83958] = true,		-- Mobile Banking
	[125439] = true,	-- Pet Bandage
	[6603] = true, 		-- Auto Attack

	[131204] = true,	-- ChallengeMode Ports
	[131205] = true,
	[131206] = true,
	[131222] = true,
	[131225] = true,
	[131231] = true,
	[131229] = true,
	[131232] = true,
	[131228] = true,
	[159895] = true,
	[159896] = true,
	[159897] = true,
	[159898] = true,
	[159899] = true,
	[159900] = true,
	[159901] = true,
	[159902] = true,
}

local Whitelist = {
	[115151] = true,	--Renewing Mist
	[18562] = true,		--Swiftmend
	[194466] = true,	--Phoenix's Flames
	[190784] = true, 	--Divine Steed
}

local function isPetSpell(SpellID)
	if IsSpellKnown(SpellID) then
		return false
	elseif IsSpellKnown(SpellID, true) then
		return true
	else
		return false
	end
end

function OCD:FindCooldown(SpellID)
	for _, Frame in pairs(Cooldowns) do
		if SpellID == Frame.SpellName then
			if self.db["Mode"] == "HIDE" then
				OCD:DelayedEnableCooldown(Frame)
			else
				OCD:EnableCooldown(Frame)
			end
			break
		end
	end
end

function OCD:DelayedEnableCooldown(self)
	local Start, Duration, Enable = GetSpellCooldown(self.SpellName);
	if (not Start) then
		return;
	end
	self:SetParent(OzCDHider)
	self:Show()
	self:SetAlpha(0)
	self:EnableMouse(false)
	self.Elapsed = 0
	self:SetScript("OnUpdate", function(self, elapsed)
		local Start, Duration, Enable = GetSpellCooldown(self.SpellName);
		if (not Start) then
			OCD:DisableCooldown(self);
			return;
		end
		local Charges, MaxCharges, ChargeStart, ChargeDuration = GetSpellCharges(self.SpellName)
		local CurrentDuration = (Start + Duration - GetTime())
		if Charges then
			Start, Duration = ChargeStart, ChargeDuration
			CurrentDuration = (ChargeStart + ChargeDuration - GetTime())
		end
		self.Elapsed = self.Elapsed + elapsed
		if self.Elapsed > 30 then
			OCD:DisableCooldown(self)
		end
		if CurrentDuration and floor(CurrentDuration) <= OCD.db["MinimumDuration"] and floor(CurrentDuration) > 1 then
			OCD:EnableCooldown(self)
			OCD:Position()
		end
	end)
end

function OCD:EnableCooldown(self)
	local Start, Duration, Enable = GetSpellCooldown(self.SpellName);
	if (not Start) then
		return;
	end
	self.Enabled = true
	self:SetParent(OCD.frame)
	self:Show()
	self:SetAlpha(1)
	self.Elapsed = 0
	self:EnableMouse(OCD.db["Tooltips"] or OCD.db["Announce"])
	self.Icon:SetDesaturated(false)
	self:SetScript("OnUpdate", function(self, elapsed)
		local Start, Duration, Enable = GetSpellCooldown(self.SpellName);
		if (not Start) then
			OCD:DisableCooldown(self);
			return;
		end
		local Charges, MaxCharges, ChargeStart, ChargeDuration = GetSpellCharges(self.SpellName)
		local CurrentDuration = (Start + Duration - GetTime())
		if Charges then
			Start, Duration = ChargeStart, ChargeDuration
			CurrentDuration = (ChargeStart + ChargeDuration - GetTime())
			if Start == (((2^32)/1000) - ChargeDuration) then
				CurrentDuration = 0
				Charges = nil
			end
		end
		if CurrentDuration and CurrentDuration > .1 then
			local Normalized = CurrentDuration / Duration
			self.StatusBar:SetValue(Normalized)
			self.DurationText:SetTextColor(1, 1, 0)
			self.Stacks:SetText(Charges or '')
			if CurrentDuration > 60 then
				self.DurationText:SetFormattedText("%dm", ceil(CurrentDuration / 60))
			elseif CurrentDuration <= 60 and CurrentDuration > 10 then
				self.DurationText:SetFormattedText("%d", CurrentDuration)
			elseif CurrentDuration <= 10 and CurrentDuration > 0 then
				self.DurationText:SetTextColor(1, 0, 0)
				self.DurationText:SetFormattedText("%.1f", CurrentDuration)
			end
			if OCD.db["FadeMode"] == "GreenToRed" then
				self.StatusBar:SetStatusBarColor(1 - Normalized, Normalized, 0)
			elseif OCD.db["FadeMode"] == "RedToGreen" then
				self.StatusBar:SetStatusBarColor(Normalized, 1 - Normalized, 0)
			end
			if OCD.db["StatusBar"] then
				self.StatusBar:Show()
				if OCD.db["DurationText"] then
					self.DurationText:Show()
				else
					self.DurationText:Hide()
				end
				self.Cooldown:Hide()
			else
				self.StatusBar:Hide()
				self.DurationText:Hide()
				self.Cooldown:Show()
				-- CooldownFrame_SetTimer(self.Cooldown, Start, Duration, Enable, Charges, MaxCharges)
				self.Cooldown:SetDrawEdge(false);
				self.Cooldown:SetDrawSwipe(true);
			end
		elseif not Charges then
			OCD:DisableCooldown(self)
			OCD:Position()
		end
	end)
end

function OCD:DisableCooldown(self)
	self:SetParent(OCD.frame)
	self.Enabled = false
	self.StatusBar:Hide()
	self.Cooldown:Hide()
	self.DurationText:Hide()
	self.Elapsed = 0
	if OCD.db["Mode"] == "HIDE" then
		self:Hide()
	else
		self:Show()
		self:SetAlpha(.3)
	end
	self:EnableMouse(false)
	self.Icon:SetDesaturated(true)
	self:SetScript("OnUpdate", nil)
end

function OCD:Position()
	local Vertical, Spacing, Size = self.db["Vertical"], self.db["Spacing"], self.db["Size"]
	local Font, StatusBarTexture, Color = LSM:Fetch("font", self.db["DurationFont"]), LSM:Fetch('statusbar', self.db["StatusBarTexture"]), self.db["StatusBarTextureColor"]
	local xSpacing = Vertical and 0 or Spacing
	local ySpacing = Vertical and -(Spacing + (self.db["StatusBar"] and 8 or 0)) or 0
	local AnchorPoint = Vertical and "BOTTOMLEFT" or "TOPRIGHT"
	local LastFrame = self.frame
	local Index = 0

	if self.db["SortByDuration"] and self.db["Mode"] == "HIDE" then
		sort(Cooldowns, function (a, b)
			local aStart, aDuration = GetSpellCooldown(a.SpellID)
			local bStart, bDuration = GetSpellCooldown(b.SpellID)
			return (aStart + aDuration) < (bStart + bDuration)
		end)
	end

	for i = 1, #Cooldowns do
		local Frame = Cooldowns[i]

		if Frame.Enabled then
			Frame:SetSize(Size, Size)
			if AS then
				Frame.StatusBar:SetSize(Size - (AS.PixelPerfect and 2 or 4), 4)
			else
				Frame.StatusBar:SetSize(Size - 2, 4)
			end
			Frame.DurationText:SetFont(Font, self.db["DurationFontSize"], self.db["DurationFontFlag"])
			Frame.StatusBar:SetStatusBarTexture(StatusBarTexture)
			Frame.StatusBar:SetStatusBarColor(Color["r"], Color["g"], Color["b"])
			Frame.Icon:SetTexture(select(3, GetSpellInfo(Frame.SpellID)))
			if self.db["Mode"] == "HIDE" then
				Frame:ClearAllPoints()
				Frame:SetPoint("TOPLEFT", LastFrame, Index == 0 and "TOPLEFT" or AnchorPoint, xSpacing, ySpacing)
				LastFrame = Frame
			end
			Index = Index + 1
		else
			if self.db["Mode"] == "DIM" and IsSpellKnown(Frame.SpellID, isPetSpell(Frame.SpellID)) and not self.DimPositioned then
				Frame:ClearAllPoints()
				Frame:SetPoint("TOPLEFT", LastFrame, Index == 0 and "TOPLEFT" or AnchorPoint, xSpacing, ySpacing)
				LastFrame = Frame
				Index = Index + 1
			end
			if self.db["Mode"] == "DIM" and IsSpellKnown(Frame.SpellID, isPetSpell(Frame.SpellID)) and self.DimPositioned then
				Index = Index + 1
			end
			if self.db["Mode"] == "HIDE" then
				Frame:SetParent(OzCDHider)
			end
		end
	end

	if self.db["Vertical"] then
		self.frame:SetHeight(Size * Index + (Index + 1) * ySpacing)
	else
		self.frame:SetWidth(Size * Index + (Index + 1) * xSpacing)
	end
end

function OCD:CreateCooldownFrame(SpellID)
	local Name, _, Icon = GetSpellInfo(SpellID)
	local Frame = CreateFrame("Button", 'OzCD_'..SpellID, self.frame)
	Frame:RegisterForClicks('AnyUp')
	Frame:SetSize(self.db["Size"], self.db["Size"])

	Frame.Icon = Frame:CreateTexture(nil, "ARTWORK")
	Frame.Icon:SetPoint('TOPLEFT', 2, -2)
	Frame.Icon:SetPoint('BOTTOMRIGHT', -2, 2)
	Frame.Icon:SetTexCoord(.08, .92, .08, .92)
	Frame.Icon:SetTexture(icon)

	Frame.DurationText = Frame:CreateFontString(nil, "OVERLAY")
	Frame.DurationText:SetFont(LSM:Fetch("font", self.db["DurationFont"]), self.db["DurationFontSize"], self.db["DurationFontFlag"])
	Frame.DurationText:SetTextColor(1, 1, 0)
	Frame.DurationText:SetPoint("CENTER", Frame, "CENTER", 0, 0)

	Frame.Stacks = Frame:CreateFontString(nil, "OVERLAY")
	Frame.Stacks:SetFont(LSM:Fetch("font", self.db["DurationFont"]), self.db["DurationFontSize"], self.db["DurationFontFlag"])
	Frame.Stacks:SetTextColor(1, 1, 1)
	Frame.Stacks:SetPoint("BOTTOMRIGHT", Frame, "BOTTOMRIGHT", 0, 2)

	Frame.StatusBar = CreateFrame("StatusBar", nil, Frame)
	Frame.StatusBar:SetSize(self.db["Size"] - 2, 4)
	Frame.StatusBar:SetStatusBarTexture(LSM:Fetch('statusbar', self.db["StatusBarTexture"]))
	Frame.StatusBar:SetStatusBarColor(self.db["StatusBarTextureColor"]["r"], self.db["StatusBarTextureColor"]["g"], self.db["StatusBarTextureColor"]["b"])
	Frame.StatusBar:SetPoint("TOP", Frame, "BOTTOM", 0, -1)
	Frame.StatusBar:SetMinMaxValues(0, 1)

	Frame.Cooldown = CreateFrame("Cooldown", nil, Frame, "CooldownFrameTemplate")
	Frame.Cooldown:SetAllPoints(Frame.Icon)

	Frame.SpellID = SpellID
	Frame.SpellName = Name

	Frame:SetTemplate();
	Frame:CreateShadow();
	Frame.Icon:SetInside();
	Frame.StatusBar:CreateBackdrop();
	Frame.StatusBar.backdrop:CreateShadow();
	Frame.StatusBar:SetPoint("TOP", Frame, "BOTTOM", 0, -1);

	Frame:SetScript('OnEnter', function(self, ...)
		if OCD.db["Tooltips"] then
			GameTooltip:SetOwner(self, 'ANCHOR_CURSOR')
			GameTooltip:ClearLines()
			GameTooltip:SetSpellByID(self.SpellID)
			GameTooltip:Show()
		end
	end)
	Frame:SetScript('OnLeave', GameTooltip_Hide)
	Frame:SetScript('OnClick', function(self)
		if OCD.db["Announce"] then
			local Channel = IsInRaid() and "RAID" or IsPartyLFG() and "INSTANCE_CHAT" or IsInGroup() and "PARTY" or "SAY"
			local Start, Duration, Enable, Charges, MaxCharges = GetSpellCooldown(self.SpellID);
			local CurrentDuration = (Start + Duration - GetTime())
			local TimeRemaining
			if CurrentDuration > 60 then
				TimeRemaining = format("%d m", ceil(CurrentDuration / 60))
			elseif CurrentDuration <= 60 and CurrentDuration > 10 then
				TimeRemaining = format("%d s", CurrentDuration)
			elseif CurrentDuration <= 10 and CurrentDuration > 0 then
				TimeRemaining = format("%.1f s", CurrentDuration)
			end
			SendChatMessage(format("My %s will be off cooldown in %s", GetSpellInfo(self.SpellID), TimeRemaining), Channel)
		end
	end)

	OCD:DisableCooldown(Frame)
	return Frame
end

function OCD:BuildSpellList()
	local TotalSpells = 0
	for i = 1, GetNumSpellTabs() do
		TotalSpells = TotalSpells + select(4, GetSpellTabInfo(i))
	end

	for i = 1, TotalSpells do
		local skilltype, id = GetSpellBookItemInfo(i, BOOKTYPE_SPELL)
		if skilltype == "SPELL" and not IsPassiveSpell(i, BOOKTYPE_SPELL) and not Blacklist[id] then
			local BaseCooldown = GetSpellBaseCooldown(id)
			if BaseCooldown and BaseCooldown > 0 or Whitelist[id] then
				PlayerCooldowns[id] = true
				if (E.private.muiMisc.ozcooldowns.spellCDs[GetSpellInfo(id)] == nil) then
					E.private.muiMisc.ozcooldowns.spellCDs[GetSpellInfo(id)] = true
				end
			end
		end
	end

	for talentGroup = 1, GetNumSpecGroups() do
		for tier = 1, MAX_TALENT_TIERS do
			for column = 1, 3 do
				local TalentID, Name, _, _, _, SpellID, _, _, _ = GetTalentInfo(tier, column, talentGroup)
				if TalentID and Name then
					local SpellID = select(7, GetSpellInfo(Name))
					if SpellID then
						local BaseCooldown = GetSpellBaseCooldown(SpellID)
						local Charges, MaxCharges, Start, Duration = GetSpellCharges(SpellID)
						if (BaseCooldown and BaseCooldown > 0) or ((MaxCharges and MaxCharges > 0) and (Duration and Duration > 1.5)) then
							PlayerCooldowns[SpellID] = true
							if (E.private.muiMisc.ozcooldowns.spellCDs[Name] == nil) then
								E.private.muiMisc.ozcooldowns.spellCDs[Name] = true
							end
						end
					end
				end
			end
		end
	end

	if not E.private.muiMisc.ozcooldowns.spellDefaults then
		E.private.muiMisc.ozcooldowns.spellDefaults = CopyTable(E.private.muiMisc.ozcooldowns.spellCDs)
	end
end

function OCD:BuildCooldowns()
	wipe(Cooldowns)

	self:BuildSpellList()

	local i = 1
	for k, v in pairs(PlayerCooldowns) do
		local SpellName = GetSpellInfo(k)
		if SpellName then
			CooldownFrames[k] = CooldownFrames[k] or OCD:CreateCooldownFrame(k)
			if CooldownFrames[k].Enabled then
				CooldownFrames[k]:EnableMouse(self.db["Tooltips"] or self.db["Announce"])
			end

			if E.private.muiMisc.ozcooldowns.spellCDs[SpellName] then
				Cooldowns[i] = CooldownFrames[k]
				i = i + 1
			elseif CooldownFrames[k] then
				OCD:DisableCooldown(CooldownFrames[k])
				CooldownFrames[k]:Hide()
			end
		end
	end

	sort(Cooldowns, function (a, b)
		local aDuration = GetSpellBaseCooldown(a.SpellID)
		local bDuration = GetSpellBaseCooldown(b.SpellID)
		if aDuration == nil and bDuration == nil then
			return true
		end
		if aDuration == nil then
			return false
		end
		if bDuration == nil then
			return true
		end
		return aDuration < bDuration
	end)

	if self.db["Mode"] == "DIM" then
		for k, v in pairs(Cooldowns) do
			v:Hide()
			if IsSpellKnown(v.SpellID, isPetSpell(v.SpellID)) then
				self:DisableCooldown(v)
			end
		end
	end

	self.DimPositioned = false
	OCD:Position()
	self.DimPositioned = true

	if self.db["Mode"] == "DIM" then
		for k, v in pairs(Cooldowns) do
			if select(2, GetSpellCooldown(v.SpellID)) then
				self:EnableCooldown(v)
			end
		end
	end
end


local function OrderedPairs(t, f)
	local a = {}
	for n in pairs(t) do tinsert(a, n) end
	sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
			else return a[i], t[a[i]]
		end
	end
	return iter
end

local SpellOptions = {}
function OCD:GenerateSpellOptions()
	wipe(SpellOptions)

	local Num = 1
	for k, v in OrderedPairs(E.private.muiMisc.ozcooldowns.spellCDs) do
		local SpellName = k
		if SpellName then
			SpellOptions[SpellName] = {
				order = Num,
				type = "toggle",
				name = SpellName,
			}
			Num = Num + 1
		end
	end
	return SpellOptions
end

function OCD:UNIT_SPELLCAST_SUCCEEDED(...)
	self:FindCooldown(select(3, ...));
end

function OCD:Initialize()
	self.db = E.db.mui.misc.ozcooldowns or P.mui.misc.ozcooldowns;
	if self.db.enable ~= true then return end
	E.private.muiMisc.ozcooldowns = E.private.muiMisc.ozcooldowns or {};
	E.private.muiMisc.ozcooldowns.spellCDs = E.private.muiMisc.ozcooldowns.spellCDs or {};

	self:RegisterEvent("SPELLS_CHANGED", 'BuildCooldowns');
	self:RegisterEvent("LEARNED_SPELL_IN_TAB", 'BuildCooldowns');
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", 'BuildCooldowns');
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

	local frame = CreateFrame("Frame", nil, E.UIParent);
	frame:SetSize(40, 40);
	frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", 0, 320)
	self.frame = frame;

	E:CreateMover(self.frame, "OzCooldownsMover", "OzCooldowns Anchor", nil, nil, nil, "ALL,GENERAL")

	self:BuildCooldowns()
	for _, Frame in pairs(Cooldowns) do
		if GetSpellCooldown(Frame.SpellName) then
			self:DelayedEnableCooldown(Frame)
		end
	end
	self:BuildSpellList()
end

local function InitializeCallback()
	OCD:Initialize()
end

E:RegisterModule(OCD:GetName(), InitializeCallback)