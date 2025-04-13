impulse.Config.MapWorkshopID = "116723263" -- commented out cause gm_construct has no workshop file, if your map does, put it here and all clients will download it!

impulse.Config.MenuCamPos = Vector(1205.890869, -4665.277832, 272.618103)
impulse.Config.MenuCamAng = Angle(-0.364012, 138.929596, 0.000000)

impulse.Config.SpawnPos1 = Vector(1402.968750, -5910.041016, -55.968750)
impulse.Config.SpawnPos2 = Vector(2451.488525, -6272.820312, 83.833603)

impulse.Config.BlacklistEnts = {
	["game_text"] = true,
	["item_healthcharger"] = true,
	["item_suitcharger"] = true
}

impulse.Config.Buttons = {}

impulse.Config.LoadScript = function()
	-- code here is ran on load
end