local ITEM = {}

ITEM.UniqueID = "cos_shirt_white_office_shirt"
ITEM.Name = "White Office Shirt"
ITEM.Desc =  "A button-up white office shirt with a collared neckline and long sleeves, made from lightweight fabric."
ITEM.Category = "Clothing"
ITEM.Model = Model("models/props_c17/BriefCase001a.mdl")
ITEM.FOV = 54.231758109009
ITEM.CamPos = Vector(24.443738937378, 7.1889691352844, 10.658709526062)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.BodygroupID = 1 -- What Bodygroup ID?
ITEM.Bodygroup = 11 --  Bodygroup Slot

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.Equipable = true
ITEM.EquipGroup = "shirt"
ITEM.CanStack = true

function ITEM:CanEquip(ply)
	local teamblacklist = { [TEAM_CA] = true, [TEAM_VORT] = true,}
	if ply:IsCP() or teamblacklist[ply:Team()] or ply.WearingRebelOutfit then
		return false
	else
		return true
	end
end

function ITEM:OnEquip(ply)
	if (not ply.WearingRebelOutfit) then
		ply:SetBodygroup(ITEM.BodygroupID, ITEM.Bodygroup)
	end
end

function ITEM:UnEquip(ply)
	if (not ply.WearingRebelOutfit) then
		ply:SetBodygroup(ITEM.BodygroupID, 0)
	end
end

impulse.RegisterItem(ITEM)
