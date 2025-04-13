local ITEM = {}

ITEM.UniqueID = "wep_frag"
ITEM.Name = "Frag Grenade"
ITEM.Desc = "A high-explosive grenade that detonates after a short delay, releasing deadly shrapnel."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/Items/grenadeAmmo.mdl")
ITEM.FOV = 20.924068767908
ITEM.CamPos = Vector(36.676216125488, -5.7306590080261, 14.326647758484)
ITEM.Weight = 1.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "grenade"
ITEM.CanStack = false

ITEM.UseName = "Equip (SINGLE USE!)"

function ITEM:OnUse(ply)
	ply:Give("weapon_frag")
    ply:Notify("You've equipped a " .. ITEM.Name .. ".")
	return true
end

impulse.RegisterItem(ITEM)
