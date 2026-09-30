local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins
local WS = W:GetModule("Skins")

local _G = _G

local hooksecurefunc = hooksecurefunc

-- ElvUI skins the Cooldown Manager itself, this only adds the MerathilisUI touches on top

local function StyleItemFrame(frame)
	if frame.Cooldown then
		frame.Cooldown:SetReverse(true)
	end

	local bar = frame.Bar
	if bar and not bar.__MERSkin then
		F.CreateStyle(bar)
		WS:CreateShadow(bar)
		bar.__MERSkin = true
	end
end

local function Viewer_OnAcquireItemFrame(_, frame)
	StyleItemFrame(frame)
end

local function HandleViewer(viewer)
	if not viewer then
		return
	end

	hooksecurefunc(viewer, "OnAcquireItemFrame", Viewer_OnAcquireItemFrame)

	for frame in viewer.itemFramePool:EnumerateActive() do
		StyleItemFrame(frame)
	end
end

function module:Blizzard_CooldownViewer()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.cooldownManager) then
		return
	end

	HandleViewer(_G.UtilityCooldownViewer)
	HandleViewer(_G.BuffBarCooldownViewer)
	HandleViewer(_G.BuffIconCooldownViewer)
	HandleViewer(_G.EssentialCooldownViewer)
end

module:AddCallbackForAddon("Blizzard_CooldownViewer")
