local ITEM = {}

ITEM.UniqueID = "cos_glasses_glasses"
ITEM.Name = "Glasses"
ITEM.Desc =  "A pair of standard glasses with a lightweight frame and clear lenses, designed for vision correction or eye protection."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_c17/BriefCase001a.mdl")
ITEM.FOV = 54.231758109009
ITEM.CamPos = Vector(24.443738937378, 7.1889691352844, 10.658709526062)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.BodygroupID = 5 -- What Bodygroup ID?
ITEM.Bodygroup = 1 --  Bodygroup Slot

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "glasses"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	local teamblacklist = { [TEAM_CA] = true, [TEAM_VORT] = true,}
	if ply:IsCP() or teamblacklist[ply:Team()] then
		return false
	else
		return true
	end
end

function ITEM:OnEquip(ply)
	ply:SetBodygroup(ITEM.BodygroupID, ITEM.Bodygroup)
end

function ITEM:UnEquip(ply)
	ply:SetBodygroup(ITEM.BodygroupID, 0)
end

impulse.RegisterItem(ITEM)
