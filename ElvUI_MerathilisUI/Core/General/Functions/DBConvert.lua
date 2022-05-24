local MER, F, E, L, V, P, G = unpack(select(2, ...))

local type = type

function MER:DBConvert()
	local db = E.db.mui
	local private = E.private.mui

	if not db.unitframes.healPrediction or type(db.unitframes.healPrediction) ~= 'table' then
		db.unitframes.healPrediction = {}
	end

	if not db.unitframes.healPrediction.texture or type(db.unitframes.healPrediction.texture) ~= 'table' then
		db.unitframes.healPrediction.texture = {}
	end
end
