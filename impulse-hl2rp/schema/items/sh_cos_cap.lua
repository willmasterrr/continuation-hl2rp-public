local ITEM = {}

ITEM.UniqueID = "cos_normal_cap"
ITEM.Name = "Cap"
ITEM.Desc = "A worn, dirty cap."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props/cs_office/Snowman_hat.mdl")
ITEM.FOV = 2
ITEM.Material = "sprops/textures/sprops_wood3"
-- ITEM.ItemColour = Color(66, 36, 23)
ITEM.CamPos = Vector(-8.2521486282349, 7.3352437019348, 431.17477416992)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.Permanent = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = ITEM.Model,
	material = ITEM.Material,
	ItemColour = ITEM.ItemColour,
	pos = Vector(1.4, 5, 0),
	ang = Angle(170, 0, 81),
	scale = .8,
	femalePos = Vector(2, 5, 0),
	femaleScale = .8,
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[12] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 12, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)
