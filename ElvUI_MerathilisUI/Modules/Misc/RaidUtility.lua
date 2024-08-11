local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")
local RU = E:GetModule("RaidUtility")

local GetSpellTexture = C_Spell.GetSpellTexture
local GetSpellCharges = C_Spell.GetSpellCharges

function module:CreateElements()
	local button = _G.RaidUtility_ShowButton

	-- Battle resurrect
	local resFrame = CreateFrame("Frame", nil, E.UIParent)
	resFrame:SetPoint("TOP", button, "BOTTOM", 0, -5)
	resFrame:SetTemplate("Transparent")
	resFrame:SetAlpha(0)

	local res = CreateFrame("Frame", nil, resFrame)
	res:Size(22, 22)
	res:Point("LEFT", 5, 0)
	F.PixelIcon(res, GetSpellTexture(20484))

	res.Count = res:CreateFontString(nil, "OVERLAY")
	res.Count:FontTemplate(nil, 16, "SHADOWOUTLINE")
	res.Count:SetText("0")
	res.Count:ClearAllPoints()
	res.Count:Point("LEFT", res, "RIGHT", 10, 0)

	res.Timer = resFrame:CreateFontString(nil, "OVERLAY")
	res.Timer:FontTemplate(nil, 16, "SHADOWOUTLINE")
	res.Timer:SetText("00:00")
	res.Timer:ClearAllPoints()
	res.Timer:SetPoint("RIGHT", res, "LEFT", -5, 0)

	res:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed > 0.1 then
			local charges, _, started, duration = GetSpellCharges(20484)
			if charges then
				local timer = duration - (GetTime() - started)
				if timer < 0 then
					self.Timer:SetText("--:--")
				else
					self.Timer:SetFormattedText("%d:%.2d", timer / 60, timer % 60)
				end

				self.Count:SetText(charges)
				if charges == 0 then
					self.Count:SetTextColor(1, 0, 0)
				else
					self.Count:SetTextColor(0, 1, 0)
				end

				resFrame:SetAlpha(1)
			else
				resFrame:SetAlpha(0)
			end

			self.elapsed = 0
		end
	end)
end

function module:RaidUtility()
	if
		not (
			E.private.general.raidUtility
			and E.private.unitframe.enable
			and E.private.unitframe.disabledBlizzardFrames.raid
		)
	then
		return
	end

	self:CreateElements()
end

module:AddCallback("RaidUtility")
