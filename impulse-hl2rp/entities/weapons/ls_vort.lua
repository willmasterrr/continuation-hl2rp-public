AddCSLuaFile()

SWEP.Base = "ls_base_melee"

SWEP.PrintName = "Vortigaunt Powers"
SWEP.Category = "impulse HL2RP Weapons"

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.HoldType = "pistol"

SWEP.WorldModel = Model("")
SWEP.ViewModel = Model("models/weapons/c_vortbeamvm.mdl")
SWEP.ViewModelFOV = 65

SWEP.Slot = 4
SWEP.SlotPos = 1

-- SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.CSMuzzleFlashes = false
SWEP.IsAlwaysRaised = true

-- CLAW STATS
SWEP.Primary.Sound = "npc/vort/claw_swing2.wav"
SWEP.Primary.ImpactSound = "npc/vort/foot_hit.wav"
SWEP.Primary.ImpactSoundWorldOnly = true
SWEP.Primary.Recoil = 1.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.HitDelay = 0.3
SWEP.Primary.Delay = 0.9
SWEP.Primary.Range = 75
SWEP.Primary.StunTime = 0.2

SWEP.NoIronsights = true

SWEP.CurrentType = 1

SWEP.Secondary.Sound = Sound("WeaponFrag.Roll")
SWEP.Secondary.ImpactSound = Sound("Canister.ImpactHard")
SWEP.Secondary.ImpactSoundWorldOnly = true
SWEP.Secondary.Recoil = 1.2 -- base recoil value, SWEP.Spread mods can change this
SWEP.Secondary.Damage = 12
SWEP.Secondary.NumShots = 1
SWEP.Secondary.HitDelay = 0.3
SWEP.Secondary.Delay = 0.9
SWEP.Secondary.Range = 75
SWEP.Secondary.StunTime = 0.2

local ShootDelay = CurTime()

local function GetTrace(owner)
	local trace = util.TraceLine({

		start = owner:GetShootPos() + owner:GetAimVector() * 25,
		endpos = owner:GetShootPos() + owner:GetAimVector() * 500,
		filter = ply
	})

	return trace.Entity, trace.HitPos
end

local CopyViewModelOrigin = SWEP.ViewModelFOV
function SWEP:PostDrawViewModel(viewmodel, player)
    self.ViewModelFOV = CopyViewModelOrigin + impulse.GetSetting("firstperson_fov")
end

if SERVER then util.AddNetworkString("VortBeamEffect.Impulse") else
	net.Receive("VortBeamEffect.Impulse", function()
		local vort = net.ReadPlayer()
		local ifshoot = net.ReadBool()
		local ifboost = net.ReadBool()

		if ifboost then
				local part = CreateParticleSystem( vort, "vortigaunt_charge_token_c", PATTACH_POINT_FOLLOW, 6 )
				local part2 = CreateParticleSystem( vort, "vortigaunt_charge_token_c", PATTACH_POINT_FOLLOW, 7 )


				timer.Simple(2, function()
					local victim, pos = GetTrace(vort)
					local id = 4
					local d = CreateParticleSystem(vort,"vortigaunt_beam", PATTACH_POINT_FOLLOW,id,Vector(0,0,0))
					d:AddControlPoint(1, Entity(0), 0, 0, pos)

					part:StopEmission( false, true, false )
					part2:StopEmission( false, true, false )
				end)

		else
			if ifshoot then
				local victim, pos = GetTrace(vort)
				local id = 4
				local d = CreateParticleSystem(vort,"vortigaunt_beam", PATTACH_POINT_FOLLOW,id,Vector(0,0,0))
				d:AddControlPoint(1, Entity(0), 0, 0, pos)
			else
				local part = CreateParticleSystem( vort, "vortigaunt_charge_token_c", PATTACH_POINT_FOLLOW, 6 )
				local part2 = CreateParticleSystem( vort, "vortigaunt_charge_token_c", PATTACH_POINT_FOLLOW, 7 )

				timer.Simple(15, function()
					if IsValid(part) then
						part:StopEmission( false, true, false )
					end

					if IsValid(part2) then
						part2:StopEmission( false, true, false )
					end
				end)
			end
		end

	end)
end

SWEP.CanShootAutomatic = false
SWEP.loadingpower = false
SWEP.DoingWallHack = false
SWEP.CannotBeamAttack = false
function SWEP:DoBeamAttack()

	if self.CannotBeamAttack then return end

	if self.CanShootAutomatic then
		if 5 > self:GetStamina() then
			if SERVER then
				return self:GetOwner():Notify("You dont have enough stamina to use this!")
			end
		else
			self:RemoveStamina(5)
		end
	else
		if (not self.loadingpower and not self.CanShootAutomatic) then
			if 50 > self:GetStamina() then
				if SERVER then
					return self:GetOwner():Notify("You dont have enough stamina to use this!")
				end
			else
				self:RemoveStamina(50)
			end
		end
	end

	if self.loadingpower then return end

	if self.CanShootAutomatic then
		if SERVER then

		timer.Simple(.5, function()
				self:GetOwner():PlayGestureAnimation("g_zapattack1")

				timer.Simple(.5, function()
					net.Start("VortBeamEffect.Impulse")
					net.WritePlayer(self:GetOwner())
					net.WriteBool(true)
					net.WriteBool(false)
					net.Broadcast()

					local victim, pos = GetTrace(self:GetOwner())
					self:GetOwner():EmitSound("npc/vort/attack_shoot.wav", 100, math.random(85, 110))
					if not victim:IsValid() then return end
					local DMG = DamageInfo()
					DMG:SetDamageType(DMG_SHOCK)
					DMG:SetDamage(34)
					DMG:SetAttacker(self:GetOwner())
					DMG:SetInflictor(self:GetOwner():GetActiveWeapon())
					DMG:SetDamagePosition(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 500)
					-- DMG:SetDamageForce(self:GetOwner():GetAimVector() * 2)
					victim:TakeDamageInfo( DMG )
				end)
			end)
		end

	else
		if SERVER then
			net.Start("VortBeamEffect.Impulse")
			net.WritePlayer(self:GetOwner())
			net.WriteBool(false)
			net.WriteBool(false)
			net.Broadcast()
			self:GetOwner():Notify('Preparing "Beam Storm"..')
		end

		self.loadingpower = true

		if SERVER then self:GetOwner():EmitSound("npc/vort/attack_charge.wav") end


		timer.Simple(5, function()
			if SERVER then
				self:GetOwner():EmitSound("npc/vort/attack_shoot.wav", 100, 110)
				self:GetOwner():Notify("Beam Storm Ready! Simply Right click to shoot a beam.")
			end
			self.CanShootAutomatic = true
			self.loadingpower = false

			timer.Simple(10, function()
				self.CanShootAutomatic = false

				if SERVER then
					self:GetOwner():EmitSound("npc/vort/attack_shoot.wav", 100, 80)
					self:GetOwner():StopSound("npc/vort/attack_charge.wav")
				end

				self.CannotBeamAttack = true

				timer.Simple(3, function() self.CannotBeamAttack = false end)
			end)
		end)
	end
end

function SWEP:WallHack()

	if self.DoingWallHack then return end

	self:RemoveStamina(20)

	if SERVER then
		self:GetOwner():EmitSound("ambient/atmosphere/city_skybeam1.wav")
		self:GetOwner():EmitSound("items/suitchargeno1.wav")
	end
	self.DoingWallHack = true

	if CLIENT then
		self:GetOwner():Notify("Enabled See through! (10 Seconds!)")
		LocalPlayer().VortWallhack = true
		if timer.Exists(self:GetOwner():SteamID64() .. ".WallhackVort") then timer.Remove(self:GetOwner():SteamID64() .. ".WallhackVort") end
		timer.Create(self:GetOwner():SteamID64() .. ".WallhackVort", 10, 1, function()
			hook.Remove("PreDrawHalos", "VortsessenceWallhack")
			LocalPlayer().VortWallhack = false
			LocalPlayer().Scan = false
			self.DoingWallHack = false

		end)
	else
		timer.Simple(10, function()
			if IsValid(self:GetOwner()) then
				self:GetOwner():Notify("See Through ended.")
				self:GetOwner():EmitSound("items/medshotno1.wav", 100, 80)
				self:GetOwner():EmitSound("items/suitchargeno1.wav", 100, 70)
				self.DoingWallHack = false

			end
		end)
	end
end

function SWEP:DoSpeedBoost()
	self:RemoveStamina(75)

	local victim, pos = GetTrace(self:GetOwner())
	if SERVER then
		self:GetOwner():Notify("Look towards a player to speed boost them!")

		net.Start("VortBeamEffect.Impulse")
		net.WritePlayer(self:GetOwner())
		net.WriteBool(false)
		net.WriteBool(true)
		net.Broadcast()

		-- self:GetOwner():DoCustomAnimEvent(PLAYERANIMEVENT_CUSTOM_SEQUENCE, self:GetOwner():LookupSequence("g_zapattack1"))
		-- self:GetOwner():DoAnimationEvent(self:GetOwner():LookupSequence("g_zapattack1"))
		self:GetOwner():EmitSound("npc/vort/attack_charge.wav", 100, 130)
		timer.Simple(1.5, function()
			self:GetOwner():PlayGestureAnimation("g_zapattack1")
			timer.Simple(.5, function()
				self:GetOwner():EmitSound("npc/vort/attack_shoot.wav", 100, 130)
				self:GetOwner():StopSound("npc/vort/attack_charge.wav")
				util.ScreenShake(pos, 80, 40, 1, 1000)
				if not victim:IsPlayer() then return end
				victim:EmitSound("items/suitchargeok1.wav", 100, 130)
				victim:EmitSound("beams/beamstart5.wav", 100, 130)
				victim:SetRunSpeed(impulse.Config.JogSpeed * 1.4)
				victim:SetWalkSpeed(impulse.Config.WalkSpeed * 1.4)
				victim:ScreenFade(SCREENFADE.IN, Color(228, 137, 33), 1, 0)
				victim:SetMaterial("models/props_lab/Tank_Glass001")
				victim:Notify("You've been speed boosted by a vortigaunt! (Boosted for 30 seconds!)")
				timer.Simple(.5, function()
					victim:SetMaterial(nil)
				end)
				if timer.Exists(victim:SteamID64() .. ".SpeedBoostVort") then timer.Remove(victim:SteamID64() .. ".SpeedBoostVort") end

				timer.Create(victim:SteamID64() .. ".SpeedBoostVort", 30, 1, function()
					if IsValid(victim) then
						victim:SetRunSpeed(impulse.Config.JogSpeed)
						victim:SetWalkSpeed(impulse.Config.WalkSpeed)
					end
				end)

			end)
		end)
	end
end

function SWEP:SecondaryAttack()
	if ShootDelay > CurTime() then return end
	ShootDelay = CurTime() + 1
	local CantRun = false
	local Sweps = {
		[1] = {func = function() self:DoBeamAttack() end, xpneeded = 1},
		[2] = {func = function() self:DoSpeedBoost() end, xpneeded = 70},
		[3] = {func = function() self:WallHack() end, xpneeded = 20},
	}

	if Sweps[self.CurrentType].xpneeded > self:GetStamina() then
		if SERVER then
			self:GetOwner():Notify("You dont have enough stamina to use this!")
		end
		CantRun = true
	end

	if Sweps[self.CurrentType] and not CantRun then
		local func = Sweps[self.CurrentType].func
		func()
	end
end

function SWEP:PrePrimaryAttack()
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("altfire"))
	if SERVER then
		self:GetOwner():PlayGestureAnimation("meleehigh" .. math.random(1,2))
	end

end

local Bar = Material("impulse/continuation/ui/vort_stamina_bar.png")
local BoostIcon = Material("impulse/continuation/ui/vort_skill_boost.png")
local WallHackIcon = Material("impulse/continuation/ui/vort_skill_wallhack.png")
local SpellIcon = Material("impulse/continuation/ui/vort_skill_spell.png")
local BarMarker = Material("impulse/continuation/ui/vort_stamina_bar_indicator.png")
local gray = Color(24, 24, 24, 234)
local board = Color(255, 208, 0)
-- local usage = Color(204, 45, 45, 180)

function SWEP:GetStamina()
	return self:GetOwner().VortStaminaBar
end

function SWEP:RemoveStamina(amount)
	self:GetOwner().VortStaminaBar = math.Clamp(self:GetOwner().VortStaminaBar - amount, 0, 100)
end

SWEP.CurTimeCheck = CurTime()

local ReloadCheck = CurTime()
function SWEP:Reload()
	if ReloadCheck > CurTime() then return end
	ReloadCheck = CurTime() + .4
	self.CurrentType = self.CurrentType + 1
	if self.CurrentType >= 4 then self.CurrentType = 1 end
	if CLIENT then
		surface.PlaySound("common/wpn_moveselect.wav")
	end
end

function SWEP:Think()
	if self.CurTimeCheck > CurTime() then return end
	self.CurTimeCheck = CurTime() + 1
	self:GetOwner().VortStaminaBar = self:GetOwner().VortStaminaBar or 100
	if self:GetOwner().VortStaminaBar >= 100 then self:GetOwner().VortStaminaBar = 100 return end
	self:GetOwner().VortStaminaBar = self:GetOwner().VortStaminaBar + 1 --1.5
end

local IconPos =
{	[1] = {x = .4375, y = .75, space = 0.2},
	[2] = {x = .4875, y = .75, space = 0.2},
	[3] = {x = .5375, y = .75, space = 0.2}, }
function SWEP:DrawHUD()
	local w, h = ScrW(), ScrH()
	local xp = self:GetOwner().VortStaminaBar or 100
	if not impulse.hudEnabled then return end
	surface.SetDrawColor(gray)
	surface.DrawRect(w * .4, h * .8, w * .2, h * .02)

	surface.SetDrawColor(color_white)

	surface.SetMaterial(SpellIcon)
	surface.DrawTexturedRect(w * .44, h * .75, w * .02, h * .035)
	surface.SetMaterial(BoostIcon)
	surface.DrawTexturedRect(w * .49, h * .75, w * .02, h * .035)
	surface.SetMaterial(WallHackIcon)
	surface.DrawTexturedRect(w * .54, h * .75, w * .02, h * .035)

	surface.SetDrawColor(board)
	surface.DrawOutlinedRect(w * IconPos[self.CurrentType].x, h * IconPos[self.CurrentType].y, w * .024, h * .035, 4)

	surface.SetDrawColor(color_white)

	surface.SetMaterial(Bar)
	surface.DrawTexturedRect(w * .4, h * .8, math.Clamp(w * (xp / 150 * 0.3), 0, w * .2), h * .02)

	surface.SetMaterial(BarMarker)
	--w * .2 max
	surface.DrawTexturedRect(w * .4 + math.Clamp(w * (xp / 150 * 0.299), 0, w * .2), h * .798, 3, h * .025)

	-- surface.SetDrawColor(usage)
	-- surface.DrawRect(w * .4, h * .8, w * IconPos[self.CurrentType].space, h * .02)
	-- surface.DrawRect(w * .1 + math.Clamp(w * (xp / 150 * 0.299), 0, w * .2), h * .8, w * IconPos[self.CurrentType].space, h * .02)

end
