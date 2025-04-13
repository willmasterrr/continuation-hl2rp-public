local VENDOR = {}

VENDOR.UniqueID = "heavy_rebel_playtest"
VENDOR.Name = "Heavy Rebel Vendor"
VENDOR.Desc = ""

VENDOR.Model = "models/Humans/Group03m/male_06.mdl"
VENDOR.Skin = 0
VENDOR.Sequence = "idle01"
VENDOR.Gender = "male" -- male, female, cp

VENDOR.Sell = {
		["wep_mini14"] = {
		Restricted = true,
		Max = 1
	},
		["wep_357"] = {
		Restricted = true,
		Max = 1
	},
		["wep_ak47"] = {
		Restricted = true,
		Max = 1
	},
		["wep_m60"] = {
		Restricted = true,
		Max = 1
	},
		["ammo_rifle"] = {
		Restricted = true,
		Max = 3
	},
		["ammo_357"] = {
		Restricted = true,
		Max = 2
	},
		["cos_combatgasmask"] = {
		Restricted = true,
		Max = 1
	},
		["cos_otavest"] = {
		Restricted = true,
		Max = 1
	},
		["item_splint"] = {
		Restricted = true,
		Max = 1
	},
		["wep_molotov"] = {
		Restricted = true,
		Max = 1
	},
	["cos_parahelmet"] = {
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
