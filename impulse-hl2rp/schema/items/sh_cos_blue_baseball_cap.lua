local ITEM = {}

ITEM.UniqueID = "cos_cap"
ITEM.Name = "Blue Baseball Cap"
ITEM.Desc = "A worn blue baseball cap with an American flag patch on the front. A symbol of patriotism and casual style."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props/cs_office/Snowman_hat.mdl")
ITEM.FOV = 2
ITEM.CamPos = Vector(-8.2521486282349, 7.3352437019348, 431.17477416992)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.Permanent = true

ITEM.Illegal = true
ITEM.Equipable = true
ITEM.EquipGroup = "head"
ITEM.CanStack = false

ITEM.CosmeticData = {
	model = ITEM.Model,
	pos = Vector(1.4, 5, 0),
	ang = Angle(170, 0, 81),
	scale = .8,
	femalePos = Vector(2, 5, 0),
	femaleScale = .8
}

impulse.Cosmetics = impulse.Cosmetics or {} -- register cosmetic into impulse
impulse.Cosmetics[11] = ITEM.CosmeticData

function ITEM:CanEquip(ply)
	return not ply:IsCP()
end

function ITEM:OnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, 11, true)
end

function ITEM:UnEquip(ply)
	ply:SetSyncVar(SYNC_COS_HEAD, nil, true)
end

impulse.RegisterItem(ITEM)
