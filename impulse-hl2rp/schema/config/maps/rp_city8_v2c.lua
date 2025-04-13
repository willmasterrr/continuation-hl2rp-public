impulse.Config.MapWorkshopID = "736405289"
impulse.Config.MapContentWorkshopID = "1406336883"

impulse.Config.MenuCamPos = Vector(-4546.6801757813, 6406.1401367188, 80.756134033203)
impulse.Config.MenuCamAng = Angle(3.2999804019928, 176.23988342285, 0)

impulse.Config.SpawnPos1 = Vector(-6267.2392578125, 6271.6782226563, -13.169764518738)
impulse.Config.SpawnPos2 = Vector(-6986.4643554688, 5556.9262695313, -320.02737426758)

impulse.Config.BroadcastPos = Vector(6858.1264648438, 1881.7979736328, -391.96875)

impulse.Config.CitySounds = {
	["ration_start"] = {audio = "city8/city8-rations.wav"},
	["cwu_start"] = {audio = "custom_sound/c8-workshift-warwick-marrison.wav"},
	-- ["ration_end"] = {audio = ""}, -- Not Used in city8.
}

impulse.Config.CityCode = "C8"
impulse.Config.OverwatchCode = "S8"
impulse.Config.BlacklistEnts = {
	["lua_run"] = true,
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

-- impulse.Config.AptsDoors = {
-- 	{name = "1-102", doors = {2224, 2227}},
-- 	{name = "1-101", doors = {2223, 2225}},
-- 	{name = "1-103", doors = {1267, 1269, 1276}},
-- 	{name = "1-202", doors = {2248, 2249}},
-- 	{name = "1-201", doors = {2262, 2263}},
-- 	{name = "1-203", doors = {1271, 1270, 1277}},
-- 	{name = "1-302", doors = {2271, 2272}},
-- 	{name = "1-301", doors = {2271, 2272}},
-- 	{name = "1-303", doors = {1272, 1273, 1279}},
-- 	{name = "1-402", doors = {2294, 2295}},
-- 	{name = "1-401", doors = {2308, 2309}},
-- 	{name = "1-403", doors = {1275, 1274, 1278}}
-- }

impulse.Config.AptsDoors = {
	{name = "1 101", doors = {2231, 2233}},
	{name = "1 102", doors = {2232, 2235}},
	{name = "1 103", doors = {1275, 1277, 1284}},
	{name = "2 201", doors = {2270, 2271}},
	{name = "2 202", doors = {2256, 2257}},
	{name = "2 203", doors = {1279, 1278, 1285}}
}

impulse.Config.Zones = {
	{name = "District 1", pos1 = Vector(-7626.3979492188, 6245.5063476563, -284.47088623047), pos2 = Vector(-4327.630859375, 6812.3637695313, 599.22155761719)},
	{name = "City Ingress", pos1 = Vector(-6930.447265625, 6225.546875, -274.18069458008), pos2 = Vector(-6214.7270507813, 5644.6489257813, -47.177169799805)},
	{name = "Hospital", pos1 = Vector(-7752.2338867188, 6834.7836914063, -212.8815612793), pos2 = Vector(-7092.6884765625, 7541.486328125, 55.272407531738)},
	{name = "Apartment Block C", pos1 = Vector(-5299.9047851563, 6283.5771484375, -309.8782043457), pos2 = Vector(-4929.4682617188, 5675.6040039063, 112.11508178711)},
	{name = "North Road", pos1 = Vector(-4935.3232421875, 6816.8627929688, 587.68109130859), pos2 = Vector(-4100.9033203125, 7600.9741210938, -291.01837158203)},
	{name = "Warehouse 3", pos1 = Vector(-3648.8083496094, 7820.4184570313, 279.89849853516), pos2 = Vector(-3011.703125, 6833.7915039063, -239.72294616699)},
	{name = "Apartment Block B", pos1 = Vector(-4163.3715820313, 7834.6181640625, -248.01040649414), pos2 = Vector(-3591.357421875, 8308.09375, 507.38922119141)},
	{name = "Civil Research Complex", pos1 = Vector(-7636.0927734375, 6806.8203125, -291.03900146484), pos2 = Vector(-9429.392578125, 6236.6630859375, 502.07827758789)},
	{name = "Civil Research Complex Lower", pos1 = Vector(-7104.4692382813, 8162.9604492188, -1227.2796630859), pos2 = Vector(-9141.8740234375, 6046.7587890625, -4183.7788085938)},
	{name = "Ration Distribution Centre", pos1 = Vector(-6729.8881835938, 10202.709960938, 304.84521484375), pos2 = Vector(-5868.935546875, 9599.1005859375, -253.75344848633)},
	{name = "District 2 South", pos1 = Vector(-4169.796875, 7611.6552734375, -304.6604309082), pos2 = Vector(-4541.2939453125, 9571.8486328125, 458.41198730469)},
	{name = "District 2 East", pos1 = Vector(-4560.2021484375, 9575.3359375, 451.17572021484), pos2 = Vector(-6081.4311523438, 9208.435546875, -274.56268310547)},
	{name = "Apartment Block A", pos1 = Vector(-4578.8823242188, 7859.0776367188, -282.69610595703), pos2 = Vector(-5007.837890625, 8303.5048828125, 501.05807495117)},
	{name = "Nexus Courtyard", pos1 = Vector(-6116.4755859375, 9204.9443359375, -285.1408996582), pos2 = Vector(-7747.4477539063, 9557.984375, 818.10321044922)},
	{name = "Detainment Block", pos1 = Vector(-7362.4970703125, 10819.130859375, -18.480697631836), pos2 = Vector(-8711.8662109375, 10115.870117188, -255.82952880859)},
	{name = "Armoury", pos1 = Vector(-8722.2421875, 10786.818359375, 332.04504394531), pos2 = Vector(-7422.0346679688, 10020.446289063, 28.126214981079)},
	{name = "Nexus Entrance", pos1 = Vector(-7957.73046875, 9814.220703125, -266.52954101563), pos2 = Vector(-8752.9619140625, 9183.0146484375, -123.55410766602)},
	{name = "Nexus North", pos1 = Vector(-5846.1904296875, 10027.142578125, 511.8564453125), pos2 = Vector(-4357.1323242188, 11175.297851563, 34.493995666504)},
	{name = "Sewers", pos1 = Vector(-2421.3913574219, -12036.381835938, -266.40115356445), pos2 = Vector(-10948.93359375, 10922.081054688, -1215.9154052734)},
	{name = "Citadel", pos1 = Vector(-1549.8157958984, -288.80767822266, -4746.974609375), pos2 = Vector(3163.7292480469, 3302.9267578125, -1471.0211181641)},
	{name = "Upper Citadel", pos1 = Vector(2067.1767578125, 3281.3681640625, -1363.6795654297), pos2 = Vector(7050.5478515625, 811.73742675781, 362.05960083008)},
	{name = "Apartment Block D", pos1 = Vector(-5915.783203125, 8024.4848632813, 537.23370361328), pos2 = Vector(-6346.3608398438, 8279.4169921875, 58.869934082031)},
	{name = "Highway", pos1 = Vector(-6427.533203125, 5932.46875, -26.195854187012), pos2 = Vector(-7005.36328125, -971.08215332031, 310.92098999023)},
	{name = "APC Depot", pos1 = Vector(-3204.1345214844, 9531.89453125, 684.16418457031), pos2 = Vector(-2472.9462890625, 8134.0654296875, -236.54934692383)},
	{name = "Training Hall", pos1 = Vector(-7607.7006835938, 10825.967773438, -2.2358524799347), pos2 = Vector(-8367.8427734375, 12070.625976563, 672.33050537109)},
	{name = "District Bypass", pos1 = Vector(-4586.2163085938, 8324.1787109375, 2.5624334812164), pos2 = Vector(-6892.4848632813, 8827.115234375, 331.64758300781)},
	{name = "Slums", pos1 = Vector(-6349.9663085938, 8283.4736328125, 50.398761749268), pos2 = Vector(-5149.6430664063, 7719.4580078125, -240.4243927002)},
	{name = "City Gate", pos1 = Vector(-2683.4602050781, -291.02990722656, 755.69635009766), pos2 = Vector(-9000.4052734375, -1923.814453125, -19.388046264648)},
	{name = "Outlands", pos1 = Vector(-9393.033203125, -2014.9470214844, 2186.6845703125), pos2 = Vector(-2726.6953125, -15119.063476563, -221.83561706543)}
}


impulse.Config.IntroScenes = {
	{
	    pos = Vector(-6387.8051757813, 6451.7973632813, 153.59359741211),
     	endpos = Vector(-6230.6049804688, 6465.9038085938, 124.45660400391),
     	posNoLerp = true,
     	posSpeed = 0.0003,
	    ang = Angle(10.459896087646, 4.9196672439575, 0),
	    fovTo = 94,
	    fovSpeed = 0.19,
     	fovNoLerp = true,
	    time = 5,
	    text = "Welcome to City 8.",
     	onStart = function()
        	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0.1)
     	end,
     	fadeOut = true
    },
	{
		pos = Vector(-4345.837890625, 8230.6982421875, -150.25643920898),
     	endpos = Vector(-4371.2124023438, 7885.2958984375, -35.99044418335),
     	posSpeed = 0.1,
     	posNoLerp = true,
	    ang = Angle(-18.260076522827, -93.480827331543, 0),
     	endang = Angle(-18.260076522827, -94.800834655762, 0),
	    text = "This is a roleplay server set in the Half-Life 2 Universe. You play as an oppressed citizen.",
	    time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(505.18441772461, 2101.7453613281, -3630.8662109375),
	    ang = Angle(-12.200016021729, -6.3800721168518, 0),
	    endpos = Vector(276.92575073242, 2147.6225585938, -3635.9033203125),
	    endang = Angle(-27.380041122437, -9.6800565719604, 0),
	    posNoLerp = true,
	    posSpeed = 0.1,
	    speed = 0.1,
	    fovFrom = 10,
	    fovTo = 75,
	    fovSpeed = 0.1,
	    text = "An interdimensional empire known commonly as the Combine has taken control of Earth.",
	    time = 13.5,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = Vector(-8051.3876953125, 10634.833984375, -49.742691040039),
	    endpos = Vector(-8272.5673828125, 10562.598632813, -18.147356033325),
	    posNoLerp = true,
	    posSpeed = 0.1,
	    ang = Angle(13.100078582764, -38.306419372559, 0),
	    text = "Metropolice and trans-human OTA units uphold the Combine's rule and squash civil resistance.",
	    time = 11,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(-6123.654296875, 9890.287109375, -157.41529846191),
     	endpos = Vector(-6117.2109375, 9713.828125, -166.4672088623),
	    ang = Angle(24.320116043091, -35.80647277832, 0),
     	endang = Angle(24.540145874023, 28.873517990112, 0),
	    text = "Tokens and food rationed by the Combine are supplied at ration dispensers around the city.",
     	speed = 0.15,
	    time = 9.5,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = Vector(-8788.9189453125, 7118.2880859375, -4101.435546875),
	    endpos = Vector(-9003.16796875, 7057.2978515625, -4065.435546875),
	    ang = Angle(-10.780172348022, -74.420356750488, 0),
	    endang = Angle(-23.760187149048, -71.560340881348, 0),
	    posSpeed = 0.18,
	    speed = 0.2,
	    fovFrom = 78,
	    fovTo = 82,
	    fovSpeed = 0.01,
	    text = "You can choose to join the Civil Workers Union and sell food, setup businesses or become a doctor.",
	    time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(-3763.7805175781, 8143.7397460938, 387.36486816406),
		endpos = Vector(-3759.5932617188, 8146.4584960938, 72.41333770752),
		ang = Angle(89, 3.2927870750427, 0),
		endang = Angle(89, 110.65320587158, 0),
		posSpeed = 0.1,
		speed = 0.1,
		text = "You can also purchase an apartment or property, decorate it or use it to store items.",
		time = 10,
	    fadeIn = true,
	    fadeOut = true
	},
	{ -- out of sync a bit
	    pos = Vector(-6822.1162109375, -5945.3012695313, 239.43130493164),
	    endpos = Vector(-6894.9643554688, -6182.01171875, 306.56689453125),
	    ang = Angle(-10.879907608032, -97.510818481445, 0),
	    endang = Angle(-9.1199169158936, -95.310806274414, 0),
	    posSpeed = 0.05,
	    posNoLerp = true,
	    speed = 0.15,
	    fovFrom = 67,
	    fovTo = 71,
	    fovSpeed = 0.14,
	    text = "If you wish to revolt, you may join the resistance, however it is no easy task...",
	    time = 12,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = impulse.Config.MenuCamPos,
	    ang = impulse.Config.MenuCamAng,
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 13,
	    text = "Welcome to impulse: Half-Life 2 Roleplay.",
	    static = true,
	    fadeIn = true,
	    onStart = function()
	    	CHAR_MUSIC = CreateSound(LocalPlayer(), "music/hl2_song2.mp3")
	    	CHAR_MUSIC:SetSoundLevel(0)
	    	CHAR_MUSIC:ChangeVolume(1.5)
	    	CHAR_MUSIC:ChangePitch(70)
	    	CHAR_MUSIC:Play()
	    end
	}
}

impulse.Config.ScannerSpawnPos = Vector(-7113.2119140625, 9035.5009765625, 431.70904541016)

impulse.Config.DealerLocations = {
	{pos = Vector(-9369.375, 7206.78125, -471.40625), ang = Angle(0, 160.6640625, 0)},
	{pos = Vector(-8901.78125, 8888.5625, -941.96875), ang = Angle(0, -166.552734375, 0)},
	{pos = Vector(-5046.625, -1755.53125, -615.96875), ang = Angle(0, 27.333984375, 0)},
	{pos = Vector(-7412.65625, -9376.34375, -231.96875), ang = Angle(0, -88.681640625, 0)}
}

impulse.Config.FishermanPos = Vector(-8745.65625, -5708.90625, -98)
impulse.Config.FishermanAng = Angle(0, -2.79052734375, 0)

impulse.Config.PrisonAngle = Angle(1.8799510002136, -177.92010498047, 0)
impulse.Config.PrisonCells = {
	Vector(-7911.21484375, 10257.44140625, -223.96875),
	Vector(-7908.3896484375, 10394.994140625, -223.96875),
	Vector(-7909.1801757813, 10532.357421875, -223.96875)
}

impulse.Config.JWButtonPos = Vector(6881.28125, 1899, -349.46875)
impulse.Config.AJButtonPos = Vector(6881.28125, 1869, -349.46875)

impulse.Config.Buttons = {
	{
		desc = "Toggle Judgement Waiver",
		pos = impulse.Config.JWButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Toggle Autonomous Judgement",
		pos = impulse.Config.AJButtonPos,
		customCheck = function(ply, button)
			return false
		end
	},
	{
		desc = "Warehouse 3 Announcement",
		pos = Vector(-3207.90625, 6852, -40),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-5665, 8370.625, 82.5),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-3590, 8345.6875, 74.25),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-4151.5, 6352.5, -182.5),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-6837.3125, 6985, 78.5),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-6816, 6097.5, 89),
		doorgroup = 1
	},
	{
		desc = "Tunnel Door Access",
		pos = Vector(-6837.3125, -825, 70.5),
		doorgroup = 1
	},
	{
		desc = "Fire Machine",
		pos = Vector(-8881, 6511, -1891.5),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Fire Machine",
		pos = Vector(-8961, 6509, -1893),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Fire Machine",
		pos = Vector(-8825.5, 6512, -1891),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Fire Machine",
		pos = Vector(-8747, 6512, -1891),
		customCheck = function(ply)
			return ply:IsSuperAdmin()
		end
	},
	{
		desc = "Lab Access",
		pos = Vector(-8477.5, 6612, -1863.59375),
		doorgroup = 3
	},
	{
		desc = "Lab Access",
		pos = Vector(-8450.5, 6892, -1863.59375),
		doorgroup = 3
	},
	{
		desc = "Closed Room",
		pos = Vector(-7031, 10693, 94.53125),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Closed Room",
		pos = Vector(-7069, 10625, 89.28125),
		customCheck = function(ply)
			return false
		end
	},
	{
		desc = "Ration Announcement",
		pos = Vector(-5880, 9615, -164),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	},
	{
		desc = "Research Complex Access",
		pos = Vector(-8703, 6784, -164),
		doorgroup = 3
	},
	{
		desc = "Research Complex Access",
		pos = Vector(-8785, 6784, -164),
		doorgroup = 3
	},
	{
		desc = "Nexus Plaza Blastdoor",
		pos = Vector(-5968, 9616, -183),
		customCheck = function(ply)
			return ply:IsAdmin()
		end
	}
}

impulse.Config.LoadScript = function()
	-- local removeMe = { -- weird func rotating thing
	-- 	3906,
	-- 	3940
	-- }

	-- for v,k in pairs(removeMe) do
	-- 	local ent = ents.GetMapCreatedEntity(k)

	-- 	if ent and IsValid(ent) then
	-- 		ent:Remove()
	-- 	end
	-- end

	-- for v,k in pairs(ents.FindByClass("prop_dynamic")) do
	-- 	if k:GetModel() == "models/props_interiors/vendingmachinesoda01a.mdl" then
	-- 		local pos, ang = k:GetPos(), k:GetAngles()
	-- 		k:Remove()

	-- 		local new = ents.Create("impulse_hl2rp_vendingmachine")
	-- 		new:SetPos(pos)
	-- 		new:SetAngles(ang)
	-- 		new:Spawn()

	-- 		local phys = new:GetPhysicsObject()

	-- 		if phys and phys:IsValid() then
	-- 			phys:EnableMotion(false)
	-- 		end
	-- 	end
	-- end

	-- for v,k in pairs(ents.FindByClass("npc_combine_camera")) do
	-- 	if k:MapCreationID() != -1 then
	-- 		local pos = k:GetPos()
	-- 		local ang = k:GetAngles()
	-- 		local values = k:GetKeyValues()

	-- 		k:Remove()

	-- 		local new = ents.Create("npc_combine_camera")
	-- 		new:SetPos(pos)
	-- 		new:SetAngles(ang)
	-- 		new:Spawn()
	-- 		new:Activate()

	-- 		new:SetKeyValue("innerradius", values.outerradius)
	-- 		new:SetKeyValue("outerradius", values.outerradius)
	-- 	end
	-- end

	-- -- get rid of abusable radios
	-- for v,k in pairs(ents.FindByClass("prop_physics")) do
	-- 	if k:GetModel() == "models/props_lab/citizenradio.mdl" then
	-- 		local phys = k:GetPhysicsObject()
	-- 		if IsValid(phys) then
	-- 			phys:EnableMotion(false)
	-- 			phys:Sleep()
	-- 		end
	-- 	end
	-- end
end