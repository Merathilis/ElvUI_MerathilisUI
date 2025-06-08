local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_UnitFrames")
local UF = E:GetModule("UnitFrames")

function module:Configure_RestingIndicator(frame)
	if not frame.RestingIndicator then
		return
	end
	local db = E.db.mui.unitframes.restingIndicator
	if not db or not db.enable then
		return
	end

	if not frame.RestingIndicator.MERHook then
		if not frame.RestingIndicator.Holder then
			frame.RestingIndicator.Holder = CreateFrame("Frame", "MER_PlayerRestLoop", E.UIParent)
			frame.RestingIndicator.Holder:Size(24)

			frame.RestingIndicator.Holder.RestTexture =
				frame.RestingIndicator.Holder:CreateTexture("MER_PlayerRestLoopRestTexture", "ARTWORK")
			frame.RestingIndicator.Holder.RestTexture:SetAllPoints(frame.RestingIndicator.Holder)
			frame.RestingIndicator.Holder.RestTexture:SetTexture(
				I.General.MediaPath .. "Textures\\UIUnitFrameRestingFlipBook.tga"
			)
			frame.RestingIndicator.Holder.RestTexture:Size(512)
			frame.RestingIndicator.Holder.RestTexture:SetParentKey("MER_PlayerRestLoopFlipBook")

			frame.RestingIndicator.Holder.PlayerRestLoopAnim = frame.RestingIndicator.Holder:CreateAnimationGroup()
			frame.RestingIndicator.Holder.PlayerRestLoopAnim:SetLooping("REPEAT")

			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook =
				frame.RestingIndicator.Holder.PlayerRestLoopAnim:CreateAnimation("FlipBook")
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetFlipBookColumns(6)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetFlipBookRows(7)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetFlipBookFrames(42)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetFlipBookFrameHeight(60)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetFlipBookFrameWidth(60)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetChildKey("MER_PlayerRestLoopFlipBook")
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetOrder(1)
			frame.RestingIndicator.Holder.PlayerRestLoopFlipBook:SetDuration(1.5)
		end

		frame.RestingIndicator.Holder:ClearAllPoints()
		frame.RestingIndicator.Holder:SetParent(frame)
		frame.RestingIndicator.Holder:Point("CENTER", frame.RestingIndicator, "CENTER", 0, 0)
		frame.RestingIndicator.Holder:SetFrameLevel(frame:GetFrameLevel() + 50)
		frame.RestingIndicator.Holder:SetScale(E.db.unitframe.units.player.RestIcon.size / 15)

		hooksecurefunc(frame.RestingIndicator, "PostUpdate", function()
			if frame.RestingIndicator:IsShown() then
				frame.RestingIndicator.Holder:Show()
				frame.RestingIndicator.Holder.PlayerRestLoopAnim:Play()
			else
				frame.RestingIndicator.Holder:Hide()
				frame.RestingIndicator.Holder.PlayerRestLoopAnim:Stop()
			end

			if not _G["MER_PlayerRestLoopRestTexture"].Gradient then
				if E.db.mui.unitframes.restingIndicator.customClassColor then
					_G["MER_PlayerRestLoopRestTexture"]:SetGradient("HORIZONTAL", F.GradientColorsCustom(E.myclass))
				else
					_G["MER_PlayerRestLoopRestTexture"]:SetGradient("HORIZONTAL", F.GradientColors(E.myclass))
				end
				_G["MER_PlayerRestLoopRestTexture"].Gradient = true
			end
		end)

		frame.RestingIndicator.MERHook = true
	end

	frame.RestingIndicator:SetTexture()
	frame.RestingIndicator.Holder:SetScale(E.db.unitframe.units.player.RestIcon.size / 15)
end

hooksecurefunc(UF, "Configure_RestingIndicator", module.Configure_RestingIndicator)
