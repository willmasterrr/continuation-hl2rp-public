local VENDOR = {}

VENDOR.UniqueID = "simple_rebel_playtest"
VENDOR.Name = "Simple Rebel Vendor"
VENDOR.Desc = ""

VENDOR.Model = "models/Eli.mdl"
VENDOR.Skin = 0
VENDOR.Sequence = "idle01"
VENDOR.Gender = "male" -- male, female, cp

VENDOR.Sell = {
	["wep_smg"] = {
		Restricted = true,
		Max = 1
	},
	["wep_pistol"] = {
		Restricted = true,
		Max = 1
	},
	["wep_shotgun"] = {
		Restricted = true,
		Max = 1
	},
	["wep_axe"] = {
		Restricted = true,
		Max = 1
	},
	["wep_pickaxe"] = {
		Restricted = true,
		Max = 1
	},
	["ammo_smg"] = {
		Restricted = true,
		Max = 3
	},
	["ammo_pistol"] = {
		Restricted = true,
		Max = 3
	},
	["ammo_buckshot"] = {
		Restricted = true,
		Max = 3
	},
	["cos_facewrap"] = {
		Restricted = true,
		Max = 1
	},
}

VENDOR.Buy = {}

function VENDOR:CanUse(ply)
	return ply:Team() == TEAM_CITIZEN
end

function VENDOR:OnItemPurchased(class, ply)
end

impulse.RegisterVendor(VENDOR)
