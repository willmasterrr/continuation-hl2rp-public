TEAM_COUNCIL = impulse.Teams.Define({
	name = "The Consul",
	color = Color(95, 42, 42),
	description = [[The Consul is the unseen hand of the Universal Union, the highest echelon of authority governing 
	Earth. Comprised of enigmatic figures who answer only to the Universal Union, they dictate policy, oversee the 
	operations of the Civil Authority, and ensure the continued subjugation of humanity. Their word is law, 
	their presence a whispered rumor among even the most loyal of officials. To defy them is to disappear 
	without a trace. While few ever glimpse The Consul, every ration cut, every decree, and every act of 
	suppression bears their silent approval.]],
	loadout = {"impulse_hands", "weapon_physgun", "gmod_tool"},
	salary = 300,
	model = "models/player/breen.mdl",
	limit = 1,
	xp = 0,
	cp = true,
	itemsAdd = {
		{class = "wep_357", amount = 1},
		{class = "wep_stunstick", amount = 1},
	},
	whitelistid = "Council_WHITELIST",
	doorGroup = {1, 2, 3, 4},
	subMaterial = {
		[5] = "impulse/continuation/council/council_sheet",
		[3] = "impulse/continuation/council/council_face",
	},
})
