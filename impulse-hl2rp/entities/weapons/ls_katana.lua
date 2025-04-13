AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Katana"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "melee2"
SWEP.NoIronsights = true

SWEP.WorldModel = Model("models/weapons_continuation/w_katana.mdl")
SWEP.ViewModel = Model("models/weapons_continuation/v_katana.mdl")
SWEP.ViewModelFOV = 50

SWEP.Slot = 4
SWEP.SlotPos = 1

--SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = ""
SWEP.Primary.ImpactSound = ""
SWEP.Primary.Recoil = 9.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 42 -- not used in this swep
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 1.5
SWEP.Primary.HitDelay = 0.4
SWEP.Primary.Range = 81
SWEP.Primary.StunTime = 0.8
SWEP.Primary.HullSize = 3

local CopyViewModelOrigin = SWEP.ViewModelFOV

function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end

function SWEP:PrePrimaryAttack()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("hitkill1"))
    if SERVER then
        local once = once or false
        if not once then once = true self.Primary.ImpactSound = "weapons/continuation/demo_sword_hit_world" .. math.random(1,2) .. ".wav"
        self:GetOwner():EmitSound("weapons/continuation/demo_sword_swing" .. math.random(1, 3) .. ".wav") end
    end
end

function SWEP:Deploy()
    if SERVER then
        local once = once or false
        if not once then once = true self:GetOwner():EmitSound("weapons/continuation/draw_sword.wav") end
    end
end
