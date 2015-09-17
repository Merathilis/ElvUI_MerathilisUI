local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local MER = E:GetModule('MerathilisUI');

if not E.db.Merathilis.Cinematic then return end

----------------------------------------------------------------------------------------
--	Skip cinematics/movies(CinematicSkip by Pigmonkey) taken from ShestakUI
----------------------------------------------------------------------------------------
-- Cancel cinematics after they start
local frame = CreateFrame("Frame")
frame:RegisterEvent("CINEMATIC_START")
frame:SetScript("OnEvent", function(_, event)
	if event == "CINEMATIC_START" then
		if not IsControlKeyDown() then
			CinematicFrame_CancelCinematic()
		end
	end
end)

-- Hook movies and stop them before they get called
local PlayMovie_hook = MovieFrame_PlayMovie
MovieFrame_PlayMovie = function(...)
	if IsControlKeyDown() then
		PlayMovie_hook(...)
	else
		GameMovieFinished()
	end
end
