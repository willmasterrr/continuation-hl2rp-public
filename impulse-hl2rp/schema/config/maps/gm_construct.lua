--impulse.Config.MapWorkshopID = "99999999" commented out cause gm_construct has no workshop file, if your map does, put it here and all clients will download it!

impulse.Config.MenuCamPos = Vector(-202.16909790039, 968.25067138672, 165.60955810547)
impulse.Config.MenuCamAng = Angle(4.2976760864258, -46.718040466309, 0)

impulse.Config.SpawnPos1 = Vector(518.02081298828, 1069.4327392578, 373.51406860352)
impulse.Config.SpawnPos2 = Vector(2293.4453125, -996.84686279297, -445.95684814453)

impulse.Config.BlacklistEnts = {
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.DealerLocations = {
	{pos = Vector(655.705994, -645.294312, -76.687347), ang = Angle(0, 0, 0)},
	{pos = Vector(667.274963, -519.253540, -74.041351), ang = Angle(0, 0, 0)},
}

impulse.Config.IntroScenes = {
	{
	    pos = Vector(-1105.4715576172, -1234.4809570313, -14.36051940918),
     	endpos = Vector(-1045.7545166016, -1343.7224121094, -14.36051940918),
     	posNoLerp = true,
     	posSpeed = 0.05,
	    ang = Angle(2.0762166976929, 28.664577484131, 0),
	    endang = Angle(2.0762166976929, 28.664577484131, 0),
	    fovFrom = 60,
	    fovTo = 94,
     	speed = 0.2,
	    time = 5,
	    text = "Welcome to the Skeleton Schema!",
     	onStart = function()
        	LocalPlayer():ScreenFade(SCREENFADE.IN, Color(0, 0, 0), 1, 0.1)
     	end,
     	fadeOut = true
    },
	{
		pos = Vector(187.76934814453, -73.89315032959, -62.653060913086),
     	endpos = Vector(68.665992736816, -243.73434448242, 286.08996582031),
     	posSpeed = 0.1,
     	posNoLerp = true,
	    ang = Angle(-17.143154144287, -131.12501525879, 0),
     	endang = Angle(-11.155171394348, -130.73854064941, 0),
	    text = "This is a simple schema that demonstrates the basics of what impulse can do. You will need basic coding experience to use it.",
	    time = 15,
	    fadeIn = true,
	    fadeOut = true
	},
	{
		pos = Vector(-2751.8967285156, -2259.8310546875, 2785.9748535156),
	    ang = Angle(17.432332992554, -45.844890594482, 0),
	    endpos = Vector(-2785.3681640625, -1418.8449707031, 2795.3032226563),
	    endang = Angle(40.418483734131, 6.7913579940796, 0),
	    posNoLerp = true,
	    posSpeed = 0.15,
	    speed = 0.1,
	    fovFrom = 75,
	    fovTo = 55,
	    fovSpeed = 0.1,
	    text = "Look at the code and build your schema from what you learn. For help check framework source code.",
	    time = 13.5,
	    fadeIn = true,
	    fadeOut = true
	},
	{
	    pos = impulse.Config.MenuCamPos,
	    ang = impulse.Config.MenuCamAng,
	    fovFrom = 40,
	    fovSpeed = 0.2,
	    time = 13,
	    text = "Welcome to impulse: Skeleton Schema.",
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

impulse.Config.Zones = {
	{name = "Spawn area", pos1 = Vector(399.33520507813, 1344.9311523438, 1067.6563720703), pos2 = Vector(2317.3337402344, -1515.2611083984, -391.20645141602)},
	{name = "Lake", pos1 = Vector(-3334.7414550781, 1563.5078125, -660.46258544922), pos2 = Vector(1117.4166259766, 6829.3505859375, 1549.6022949219)},
	{name = "Weird room", pos1 = Vector(-971.84545898438, -993.80676269531, 353.15579223633), pos2 = Vector(-3066.0302734375, -2074.6345214844, -116.8119354248)},
	{name = "The MaTRiXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", pos1 = Vector(-750.43322753906, -2586.3601074219, 136.55348205566), pos2 = Vector(-3371.5285644531, -4646.4916992188, -296.34191894531)}
}

impulse.Config.Buttons = {}

impulse.Config.LoadScript = function()
	-- code here is ran on load
end