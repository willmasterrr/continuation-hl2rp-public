local ITEM = {}

ITEM.UniqueID = "wep_katana"
ITEM.Name = "Katana"
ITEM.Desc = 'A hand-made katana made out of metal scrap, legends say a "Local City8 Samurai" used a weapon somewhat like this..'
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons_continuation/w_katana.mdl")
ITEM.FOV = 24.462750716332
ITEM.CamPos = Vector(-12.607449531555, 15.472779273987, 61.318050384521)
ITEM.Weight = 6

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "melee"
ITEM.CanStack = false

ITEM.WeaponClass = "ls_katana"

impulse.RegisterItem(ITEM)
