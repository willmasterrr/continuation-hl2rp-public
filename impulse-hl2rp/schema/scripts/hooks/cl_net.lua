-- unused for now

net.Receive("Impulse_CreateVGUI", function()
    local vgi = net.ReadString()
    vgui.Create(vgi)
end)

local wepDesc = {
	["ls_mp7"] = "The corpse contains 4.65mm rounds.",
	["ls_m60"] = "The corpse contains 7.62mm rounds.",
	["ls_357"] = "The corpse contains .357 rounds.",
	["ls_mini14"] = "The corpse contains 7.62mm rounds.",
	["ls_spas12"] = "The corpse has been ripped apart by buckshot rounds.",
	["ls_ar2"] = "The corpse has been pentrated by a high energy round which has left burn marks.",
	["ls_pickaxe"] = "The skull has a missing fragment and has partially ruptured.",
	["ls_axe"] = "The corpse has been hacked and slashed.",
	["ls_doublebarrel"] = "The torso has been seperated from the legs by several buckshot shells.",
	["ls_goldengun"] = "The corpse contains 24 carrat gold .357 rounds.",
	["ls_stunstick"] = "The corpse has several burn wounds commonly created by contact with a charged stun baton.",
	["ls_usp"] = "The corpse contains 9mm rounds.",
	["ls_vort"] = "The corpse has sustained electrical and plasma burns by an extremely powerful force."
}

local damageSent = {
	[1] = "The corpse has sustained blunt damage.",
	[2] = "The corpse has several bullet entry and exit wounds. Bullet fragments are still present in the body.",
	[3] = "The corpse has burn marks and shrapnel entry wounds. Possibly caused by an explosion.",
	[4] = "The corpse has broken and fractured legs. The torso is severely bruised."
}

net.Receive("impulseHL2RPInspectBodyComplete", function()
	local wasFall = net.ReadBool()
	local wep = net.ReadString()
	local killer = net.ReadString()
	local msg = "The inspection of the body has revealed the following:\n"
	local wDesc = wepDesc[wep]
	local dmgType = 3

	if wep == "ls_axe" or wep == "ls_pickaxe" or wep == "ls_stunstick" then
		dmgType = 1
	elseif wDesc then
		dmgType = 2
	elseif wasFall then
		dmgType = 4
	end

	msg = msg..damageSent[dmgType]

	if wDesc then
		msg = msg.."\n"..wDesc
	end

	if killer != "" then
		msg = msg.."\n\nAfter review of the bodycam footage the suspect who killed this officer has been identified as "..killer.."."
		msg = msg.."\nThey have automatically been added to the BOL index."
	end

	Derma_Message(msg, "impulse", "Close")
	print(msg)
end)