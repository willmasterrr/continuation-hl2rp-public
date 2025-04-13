AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "Mac-10"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model("models/weapons/w_smg_mac10.mdl")
SWEP.ViewModel = Model("models/weapons/v_smg_mac10.mdl")
SWEP.ViewModelFOV = 80
SWEP.ViewModelFlip = true
SWEP.UseHands = true
SWEP.Slot = 2
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("weapons/zoom.wav")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Primary.Sound = Sound("weapons/fiveseven/fiveseven-1.wav")
SWEP.Primary.Recoil = 1.3 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 4.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.038
SWEP.Primary.Delay = RPM(1457)

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 45

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0
SWEP.Spread.Max = 5
SWEP.Spread.IronsightsMod = 0.97 -- multiply
SWEP.Spread.CrouchMod = 0.95 -- crouch effect (multiply)
SWEP.Spread.AirMod = 1.2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 0.1 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(6.445, -6, 3)
SWEP.IronsightsAng = Angle(0, 8, 8)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 1
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = .06

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end
