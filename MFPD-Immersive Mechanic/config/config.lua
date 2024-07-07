--********************************************************************************--
--*                                                                                *--
--*       MFPD - ImmersiveMechanic! by MajorFivePD (dsvipeer on github)             *--
--*                                                                               *--
--********************************************************************************--

Config = {}

Config.InitialAreas = { -- Zones of initial interaction, you need to leave your vehicle and press "E" then "Mechanic" will be there.
	vector4(1180.176, 2643.481, 37.80919, 265.8721),
	vector4(109.9869, 6621.326, 31.78726, 131.1113),
	vector4(729.8083, -1084.292, 22.16906, 335.1567),
	vector4(-346.5706, -133.4381, 39.00966, 64.63951)
}

Config.MechanicCoords = { -- Mechanic zone to appear, he will spawn during your screen fade out, and you will only see him after fade in.
	vector4(1177.081, 2638.12, 37.75382, 9.493977),
    vector4(107.3478, 6627.205, 31.78723, 254.0587),
	vector4(736.2111, -1083.648, 22.16888, 142.2421),
	vector4(-339.785, -140.9135, 39.00966, 53.93643)
}

Config.FinalAreas = { -- Area which you must enter your vehicle and press the "Honk" to start the repair;
                      -- The mechanic will walk up towards your vehicle no matter how far you parked from him, just need to be inside the radius you set.
	{coords = vector4(1175.111, 2641.058, 37.41653, 179.9), radius = 10.0},
	{coords = vector4(111.7523, 6625.582, 31.33243, 44.92333), radius = 10.0},
	{coords = vector4(731.7255, -1088.862, 21.71546, 270.3717), radius = 10.0},
	{coords = vector4(-343.7899, -137.4656, 38.55816, 271.6013), radius = 10.0}
}

Config.MechanicModel = `u_m_y_smugmech_01` -- Mechanic model can be changed here, if you set a model which has clothing variation, it will spawn w/ random clothing each time.
Config.MechanicAnimDict = "mini@repair" -- default dictionary that works flawlessly, do not change unless you know what you are doing.
Config.MechanicAnimName = "fixing_a_ped" -- default animation that works flawlessly, do not change unless you know what you are doing.
Config.UseBlips = false -- This enable/disable the CUSTOM MAP BLIPS that I've placed throught the mechanic shops around the map.
