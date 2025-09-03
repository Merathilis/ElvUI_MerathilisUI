local MER, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Skins") ---@type Skins

local _G = _G
local hooksecurefunc = hooksecurefunc
local format = format
local unpack = unpack

local WeakAuras = _G.WeakAuras

---Create backdrop and shadow for a frame with common settings
---@param frame Frame The frame to apply backdrop and shadow to
---@param useDefaultTemplate boolean? Whether to use default template
local function CreateBackdropAndShadow(frame, useDefaultTemplate)
	if not frame or frame.__MERBackdrop then
		return
	end

	frame:CreateBackdrop(not useDefaultTemplate and "Transparent")

	module:CreateBackdropShadow(frame, true)

	frame.backdrop.Center:StripTextures()
	frame.__MERBackdrop = true
end

---Apply ElvUI texture coordinates to an icon
---@param icon Texture The icon texture to apply coordinates to
local function ApplyElvUITexCoords(icon)
	if not icon then
		return
	end

	F.InternalizeMethod(icon, "SetTexCoord")
	F.CallMethod(icon, "SetTexCoord", unpack(E.TexCoords))
end

---Handle complex texture coordinate calculations for icons
---@param icon Texture The icon texture to handle
local function HandleComplexTexCoords(icon)
	if not icon then
		return
	end

	icon.__SetTexCoord = icon.SetTexCoord
	icon.SetTexCoord = function(self, ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		local cLeft, cRight, cTop, cDown
		if URx and URy and LRx and LRy then
			cLeft, cRight, cTop, cDown = ULx, LRx, ULy, LRy
		else
			cLeft, cRight, cTop, cDown = ULx, ULy, LLx, LLy
		end

		if cLeft == 0 or cRight == 0 or cTop == 0 or cDown == 0 then
			local width, height = cRight - cLeft, cDown - cTop
			if width == height then
				-- For square textures, use standard ElvUI coordinates
				self:__SetTexCoord(unpack(E.TexCoords))
			else
				-- Use ElvUI's CropRatio for aspect ratio adjustment
				self:__SetTexCoord(E:CropRatio(width, height))
			end
		else
			self:__SetTexCoord(cLeft, cRight, cTop, cDown)
		end
	end

	icon:SetTexCoord(icon:GetTexCoord())
end

---Sync backdrop alpha with icon alpha
---@param frame Frame The frame containing the backdrop
---@param icon Texture The icon to sync with
local function SyncBackdropAlpha(frame, icon)
	if not frame.backdrop or not icon then
		return
	end

	frame.backdrop.icon = icon
	frame.backdrop:HookScript("OnUpdate", function(self)
		self:SetAlpha(self.icon:GetAlpha())
		if self.MERshadow then
			self.MERshadow:SetAlpha(self.icon:GetAlpha())
		end
	end)
end

---Skin an icon region
---@param frame Frame The icon frame to skin
local function SkinIconRegion(frame)
	if not frame or frame.__MERSkin then
		return
	end

	if frame.icon then
		HandleComplexTexCoords(frame.icon)
	end

	CreateBackdropAndShadow(frame)

	if frame.icon then
		SyncBackdropAlpha(frame, frame.icon)
	end

	frame.__MERSkin = true
end

---Skin an aurabar region
---@param frame Frame The aurabar frame to skin
local function SkinAurabarRegion(frame)
	if not frame or frame.__MERSkin then
		return
	end

	CreateBackdropAndShadow(frame)

	if frame.icon then
		ApplyElvUITexCoords(frame.icon)
	end

	if frame.iconFrame then
		frame.iconFrame:SetAllPoints(frame.icon)
		frame.iconFrame:CreateBackdrop()

		-- Sync icon frame backdrop visibility with icon
		hooksecurefunc(frame.icon, "Hide", function()
			frame.iconFrame.backdrop:SetShown(false)
		end)

		hooksecurefunc(frame.icon, "Show", function()
			frame.iconFrame.backdrop:SetShown(true)
		end)
	end

	frame.__MERSkin = true
end

---Main function to skin WeakAuras regions
---@param frame Frame The frame to skin
---@param regionType string The type of region ("icon", "aurabar", etc.)
local function SkinWeakAuras(frame, regionType)
	if not frame or frame.__MERSkin then
		return
	end

	if regionType == "icon" then
		SkinIconRegion(frame)
	elseif regionType == "aurabar" then
		SkinAurabarRegion(frame)
	end
end

function module:WeakAuras()
	if not E.private.mui.skins.enable or not E.private.mui.skins.addonSkins.weakAuras then
		return
	end

	if not WeakAuras or not WeakAuras.Private then
		local alertMessage = format(
			"%s %s %s",
			L["You are using Official WeakAuras, the skin of WeakAuras will not be loaded due to the limitation."],
			L["If you want to use WeakAuras skin, please install |cffff0000WeakAurasPatched|r (https://wow-ui.net/wap)."],
			L["You can disable this alert via disabling WeakAuras Skin in Skins - Addons."]
		)
		E:Delay(10, F.Print, alertMessage)
		return
	end

	if WeakAuras.Private.SetTextureOrAtlas then
		hooksecurefunc(WeakAuras.Private, "SetTextureOrAtlas", function(icon)
			local parent = icon:GetParent()
			local region = parent.regionType and parent or parent:GetParent()
			if region and region.regionType then
				SkinWeakAuras(region, region.regionType)
			end
		end)
	end
end

module:AddCallbackForAddon("WeakAuras")
