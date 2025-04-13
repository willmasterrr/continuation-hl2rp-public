local ITEM = {}

ITEM.UniqueID = "att_suppressor"
ITEM.Name = "Suppressor"
ITEM.Desc =  "An suppressor that can be attached to a pistol."
ITEM.Category = "Attachments"
ITEM.Model = Model("models/props_lab/box01a.mdl") -- models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl
ITEM.FOV = 3.4613393647694
ITEM.CamPos = Vector(-93.591636657715, -147.62672424316, -5.6738662719727)
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "secondary_attachment"
ITEM.CanStack = false

ITEM.AttachmentClass = "suppressor_atch"

impulse.RegisterItem(ITEM)
