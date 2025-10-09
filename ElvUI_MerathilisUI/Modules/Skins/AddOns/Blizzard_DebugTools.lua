local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local next = next

function module:Blizzard_DebugTools()
	if not self:CheckDB("debug", "debugTools") then
		return
	end

	self:CreateShadow(_G.TableAttributeDisplay)
	self:SecureHook(_G.TableInspectorMixin, "OnLoad", "CreateBackdropShadow")

	local developerConfig = E.global.mui.developer.tableAttributeDisplay
	if not developerConfig.enable then
		return
	end
	local diffWidth = developerConfig.width - 500
	local diffHeight = developerConfig.height - 400

	_G.TableAttributeDisplay:Size(500 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.TitleButton:Size(360 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.TitleButton.Text:Size(360 + diffWidth, 400 + diffHeight)
	_G.TableAttributeDisplay.LinesScrollFrame:Size(430 + diffWidth, 300 + diffHeight)
	hooksecurefunc(_G.TableAttributeDisplay.dataProviders[2], "RefreshData", function(dataProvider)
		local scrollFrame = dataProvider.LinesScrollFrame or _G.TableAttributeDisplay.LinesScrollFrame
		if not scrollFrame then
			return
		end
		for _, child in next, { scrollFrame.LinesContainer:GetChildren() } do
			if child.ValueButton and not child.ValueButton.__MERSkin then
				child.ValueButton:Size(310 + diffWidth, 16)
				child.ValueButton.Text:Size(310 + diffWidth, 16)
				F.SetFont(child.ValueButton.Text)
				child.ValueButton.__MERSkin = true
			end
		end
	end)
end

module:AddCallbackForAddon("Blizzard_DebugTools")
