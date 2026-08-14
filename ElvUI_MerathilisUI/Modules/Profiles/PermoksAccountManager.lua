local MER, W, WF, F, E, I, V, P, G, L = unpack(ElvUI_MerathilisUI)
local module = MER:GetModule("MER_Profiles") ---@class Profiles
local Splash = MER:GetModule("MER_SplashScreen") ---@class SplashScreen

local _G = _G

function module:LoadPermoksAccountManager()
	local PAMAPI = _G.PAMAPI

	local Profile =
		[[fwvVUTXrqyBWiqikyyj7i7yhyGawyfsGKczz5eJ44yklzzzfl6tYuf5NJ7D3C3Tr7D7MD3JY0LSiiiL6niSmLeWVaQiaPBG6DrsrksPEcYShjTeqks1D7SZoZSFZ38Tx8AAPYYL5MF(d8K2uqVHUqfXSq0CJI1SmyxRMzzT28PpzZrcwai2jo2a2fvZxUAnPOilFFEKn99QniwMB3L)A46Qf)XcWyxtMPeGl(uy45jdMyaojSqRH8W(pnKYD3tkmWUHsnqHtQ7gei1rGEvDqsPHT28H)2nV5xDHlCH)7pvgarjGlPZ5f()6SAEUfYCjTT0WDfMNMNKAhzsLhUt(65wqNoKQMDkScEo0vDv3oRvwT2DvqO7SPQfk9FmY1QWAjB6GYVMoyL0rh6aK2G(rc7FE64n2dELTeNE7GFOWy5X93myT1F(ER7nASdJ3CyyktZcP6W05yJuBB1FBWyaD3bz88THEG4n6qzwavDPbJDWReUulC2rPu3MLa3sTqeeZke21OwAIuZbZVRlYfYWdmDORelqarPTYPgT(LJnJ1FBqykxezQnS87oUGxBOue5Fiahi63bVDkU0WDerF0(LgW6VbB0uhWt8J4jQ5DGJFFzH2pdSwbGnVn(jj4NYpYfKigFAmoYfJh7wJ1)dSrnSzTGX5iEykpc2tMKiaYXGPjQkE7UyJxtnaMWrx5cJVrY1aCelOipILhchlKgRVasG8iJ6kgRuNX0uRYNzmoWGAQuNKZeod8K8mQ3AovPH(g)ChDGChgEOutvBG0yWM9WvQGF(LW7nlE3zWpBoC1Q49VSxpx06GnxvnFIgyw)sd(AgpAMtpVfvpvv1cN3cnhuyQGnUp(L4xGpaRpJ7MTKxh3UtgpStX7MB4YpLzkTujS0WpUfVXuiPHdkBSfUcExCv8Eb0bLhM7ouGJpy5vhXYy5CFAemaQCkbB(gAySqqGIT)mu)Il6b6mjHqHuxZ6YGhOkSmhbhR3FsgEmUoUgUHMawqZeX4YufRFY4vy9lw2B(NtEhn85eTkGlCC2wjuRFWbectmDyObuUstQxwnFiPVii7(UZLaMrgAVd8JiLjJAHCiOqilm(9K8iNeXzN9odjcG0putkndZ6BtN877Cyf1vDgOdfrxS4yq7tvG6gN9VVHYjT5e1iS5FJF9SyNpe3764ZNd9UkU7Iy7lJ7Fl8L3a3UkUvf8zZG7Cj8flmsPLX0OjVCOVznCPrTpZcw)fLOwTwo2GRBCKrrvsmtiM9expWDHmkI6ot5YiICKP5X2kQRq8VWuFQDqQOcItZmvD4)3HFl(943G1RuYvA5rr(4juLZnv5nzIAXXtultKpk))0q67Kj4h5LkZL6zknvc3MhEeP26rn88K5(lMtAy8I707oZoG08k1ZRGEp48BUCVLRIlTC7oTX6)A519xWumc5ycgJEiGHQB4udEsbjK8iRTihCdBtKmp2W6btfI7s3eQxLTT7zfZgTCc11gmTZuly8U18klKATCp1mC9xrdTgZHS(QBnbhwBk5BdU2yNg80JDYjteb7NQE)Z)(ZuNWRmY51(mDalpQlXmlt5zsNxd3mUKJFFCl8zUH2lwocGpLKaCuJhuLyhhn9jgt3)9p]]
	PAMAPI.Import(Profile)
end

function module:ApplyPermoksAccountManagerProfile()
	if not E:IsAddOnEnabled("PermoksAccountManager") then
		WF.Developer.LogWarning("PermoksAccountManager is not enabled. Will not apply profile.")
		return
	end

	Splash:Wrap("Applying PermoksAccountManager Profile ...", function()
		self:LoadPermoksAccountManager()

		E:UpdateMedia()
		E:UpdateFontTemplates()

		-- execute elvui update, callback later
		self:ExecuteElvUIUpdate(function()
			Splash:Hide()

			F.Event.TriggerEvent("MER.DatabaseUpdate")
		end, true)
	end, true, "PermoksAccountManager")
end
