local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Misc")

local _G = _G
local CreateFrame = CreateFrame

function module:WeakAuraAnchorLoad()
	local frame = CreateFrame("Frame", "MERWAAnchor", E.UIParent, "BackdropTemplate")
	frame:SetParent(_G["ElvUF_Player"])
	frame:SetPoint("BOTTOM", E.UIParent, "BOTTOM", F.Dpi(0), F.Dpi(470))
	frame:SetFrameStrata("BACKGROUND")
	frame:SetSize(300, 50)

	E:CreateMover(frame, "MERWAAnchorMover", MER.Title .. " WA Anchor", nil, nil, nil, "ALL,SOLO,MERATHILISUI")
end

function module:WeakAuraAnchor()
	-- Get Frameworks
	local UF = E:GetModule("UnitFrames")

	-- Enable!
	if UF.unitstoload ~= nil then
		self:SecureHook(UF, "LoadUnits", "WeakAuraAnchorLoad")
	else
		self:WeakAuraAnchorLoad()
	end
end

module:AddCallback("WeakAuraAnchor")
