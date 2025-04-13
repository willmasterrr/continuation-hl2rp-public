local ITEM = {}

ITEM.UniqueID = "wep_mac10"
ITEM.Name = "Mac-10"
ITEM.Desc =  "A lightweight automatic machine that fires 9mm rounds."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/w_smg_mac10.mdl")
ITEM.FOV = 24.190544412607
ITEM.CamPos = Vector(-16.045845031738, 17.191976547241, 3.4383955001831)
ITEM.NoCenter = true
ITEM.Weight = 0.8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_mac10"

impulse.RegisterItem(ITEM)
