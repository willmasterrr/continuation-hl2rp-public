AddCSLuaFile()

SWEP.Base = "ls_base"

SWEP.PrintName = "USP Match"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "revolver"

SWEP.WorldModel = Model("models/weapons/w_pistol.mdl")
SWEP.ViewModel = Model("models/weapons/c_pistol.mdl")
SWEP.ViewModelFOV = 55

SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.EmptySound = Sound("Weapon_Pistol.Empty")

SWEP.Primary.Sound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Recoil = 0.6 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 13
SWEP.Primary.NumShots = 1
SWEP.Primary.Cone = 0.018
SWEP.Primary.Delay = RPM(425)

SWEP.SuppressorSound = Sound("weapons/usp/usp1.wav")

SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Automatic = false
SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 18

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.Spread = {}
SWEP.Spread.Min = 0.008
SWEP.Spread.Max = 0.1
SWEP.Spread.IronsightsMod = 0.9 -- multiply
SWEP.Spread.CrouchMod = 1 -- crouch effect (multiply)
SWEP.Spread.AirMod = 2 -- how does if the player is in the air effect spread (multiply)
SWEP.Spread.RecoilMod = 0 -- how does the recoil effect the spread (sustained fire) (additional)
SWEP.Spread.VelocityMod = 1.025 -- movement speed effect on spread (additonal)

SWEP.IronsightsPos = Vector(-6.035, 0, 3.029)
SWEP.IronsightsAng = Angle(0.2, -1.3, 1)
SWEP.IronsightsFOV = 0.75
SWEP.IronsightsSensitivity = 0.8
SWEP.IronsightsCrosshair = false
SWEP.IronsightsRecoilVisualMultiplier = 2

SWEP.DrawOtherWorldModel = false

local copyIronFOV = SWEP.IronsightsFOV + 0
local CopyWorldModel = SWEP.WorldModel
local copyIronSens = SWEP.IronsightsSensitivity + 0
local copyCone = SWEP.Primary.Cone + 0
local copyIronMod = SWEP.Spread.IronsightsMod + 0
local copyVelMod = SWEP.Spread.VelocityMod + 0
local copyDamage = SWEP.Primary.Damage + 0
local copyRPM = SWEP.Primary.Delay + 0
local copyShootSound = SWEP.Primary.Sound

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
    if IsValid(self.model) then
        timer.Simple(0, function()
            if not IsValid(self.model) then return end
            self.model:Remove()
        end)
    end
end

-- function SWEP:DrawWorldModel()
--     self:DrawModel()

--     if self.DrawOtherWorldModel then

--         local matrix = self:GetBoneMatrix(1)
--         local pos = matrix:GetTranslation()
--         local ang = matrix:GetAngles()
--         local f = ang:Forward()
--         local u = ang:Up()
--         local r = ang:Right()

--         ang:RotateAroundAxis(u, 2)
--         ang:RotateAroundAxis(r, 175)

--         if IsValid(self.model) then
--             self.model:SetPos(pos + f * 14.2 + r * 1)
--             self.model:SetAngles(ang)
--         end

--         if not IsValid(self.model) then
--             self.model = ents.CreateClientProp("models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl")
--         end
--     else
--         if IsValid(self.model) then
--             timer.Simple(0, function()
--                 if not IsValid(self.model) then return end
--                 self.model:Remove()
--             end)
--         end
--     end
-- end

SWEP.Attachments = {
	suppressor_atch = {
		Cosmetic = {
			Model = "models/weapons/tfa_ins2/upgrades/a_suppressor_pistol.mdl",
			Bone = "ValveBiped.square",
			Pos = Vector(0, 0, 8),
			Ang = Angle(90, 92, 0),
			Scale = 1,
			Skin = 0
		},
		ModSetup = function(e)
			e.Primary.Sound = "weapons/usp/usp1.wav"
            -- e.DrawOtherWorldModel = true
            e.WorldModel = "models/weapons/w_pist_usp_silencer.mdl"
		end,
		ModCleanup = function(e)
			e.Primary.Sound = copyShootSound
            -- e.DrawOtherWorldModel = false
            e.WorldModel = CopyWorldModel
		end,
	}
}

