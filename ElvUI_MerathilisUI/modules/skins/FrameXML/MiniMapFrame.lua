local MER, E, L, V, P, G = unpack(select(2, ...))
local MERS = MER:GetModule("muiSkins")
local S = E:GetModule("Skins")

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
--WoW API / Variables
local hooksecurefunc = hooksecurefunc

--Global variables that we don't cache, list them here for the mikk's Find Globals script

local function styleMinimap()
	if E.private.skins.blizzard.enable ~= true or E.private.muiSkins.blizzard.minimap ~= true or E.private.general.minimap.enable ~= true then return end

	local Minimap = _G.Minimap

	Minimap:Styling(true, true, false, 180, 180, .75)

	-- QueueStatus Button
	_G.QueueStatusMinimapButtonBorder:Hide()
	_G.QueueStatusMinimapButtonIconTexture:SetTexture(nil)

	local queueIcon = Minimap:CreateTexture(nil, "ARTWORK")
	queueIcon:SetPoint("CENTER", _G.QueueStatusMinimapButton)
	queueIcon:SetSize(50, 50)
	queueIcon:SetTexture("Interface\\Minimap\\Raid_Icon")

	local anim = queueIcon:CreateAnimationGroup()
	anim:SetLooping("REPEAT")
	anim.rota = anim:CreateAnimation("Rotation")
	anim.rota:SetDuration(2)
	anim.rota:SetDegrees(360)

	hooksecurefunc("QueueStatusFrame_Update", function()
		queueIcon:SetShown(_G.QueueStatusMinimapButton:IsShown())
	end)
	hooksecurefunc("EyeTemplate_StartAnimating", function() anim:Play() end)
	hooksecurefunc("EyeTemplate_StopAnimating", function() anim:Stop() end)

	-- Difficulty Flags
	local flags = {"MiniMapInstanceDifficulty", "GuildInstanceDifficulty", "MiniMapChallengeMode"}
	for _, v in pairs(flags) do
		local flag = _G[v]
		flag:SetScale(.75)
	end
end

S:AddCallback("mUISkinMinimap", styleMinimap)
