local ITEM = {}

ITEM.UniqueID = "ammo_empty"
ITEM.Name = "Empty Ammunition Box"
ITEM.Desc = "An empty box of ammunition."
ITEM.Category = "Ammo"
ITEM.Model = Model("models/items/boxsrounds.mdl")
ITEM.FOV = 30.179083094556
ITEM.CamPos = Vector(-13.753582000732, 36.676216125488, 17.191976547241)
ITEM.NoCenter = true
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true



ITEM.UseName = "Unload"
ITEM.UseWorkBarTime = 3 --3
ITEM.UseWorkBarName = "Unloading ammo.."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "weapons/smg1/switch_burst.wav"

local AmmoList = {
	[3] = { type = "pistol", ammotogive = "ammo_pistol" }, -- pistol
	[1] = { type = "ar2", ammotogive = "ammo_ar2" }, -- ar2
	[41] = { type = "Rifle", ammotogive = "ammo_rifle" }, -- rifle
	[5] = { type = "357", ammotogive = "ammo_357" }, -- 357
	[7] = { type = "buckshot", ammotogive = "ammo_buckshot" }, -- shotgun
	[4] = { type = "smg1", ammotogive = "ammo_smg" }, -- smg
}

function ITEM:OnUse(ply)
	if ply:IsCP() then return false end

	if impulse.Ops.EventManager.GetEventMode() then
		ply:Notify("You cannot refill your ammo around this time.")
		return false
	end

	local wep = ply:GetActiveWeapon()
	if not wep then return false end

	local ammotype = wep:GetPrimaryAmmoType()


	if ammotype == -1 then
		return false
	elseif AmmoList[ammotype] and (wep:Clip1() == wep:GetMaxClip1()) then
		wep:SetClip1(0)
		ply:GiveInventoryItem(AmmoList[ammotype].ammotogive)
		ply:Notify("Refilled Ammunition.")
		return true
	else
		ply:Notify("You cant use this with the current amount of ammo, it has to be exactly " .. wep:GetMaxClip1() .. " Bullets.")
		return false
	end

	return false
end



impulse.RegisterItem(ITEM)
