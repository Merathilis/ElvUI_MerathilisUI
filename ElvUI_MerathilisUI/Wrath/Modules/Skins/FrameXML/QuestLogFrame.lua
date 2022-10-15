local MER, F, E, L, V, P, G = unpack(select(2, ...))
local module = MER:GetModule('MER_Skins')
local S = E:GetModule('Skins')

local _G = _G

local function LoadSkin()
	if not module:CheckDB("quest", "quest") then
		return
	end

	local QuestLogFrame = _G.QuestLogFrame
	QuestLogFrame.backdrop:Styling() -- need to be on the backdrop >.>
	module:CreateBackdropShadow(QuestLogFrame)

	local QuestLogDetailFrame = _G.QuestLogDetailFrame
	QuestLogDetailFrame.backdrop:Styling() -- need to be on the backdrop >.>
    module:CreateBackdropShadow(QuestLogDetailFrame)


end

S:AddCallback("QuestFrame", LoadSkin)
